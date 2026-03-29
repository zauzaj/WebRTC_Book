class InvoiceExtractorService
  GPT_MODEL = "gpt-4o"

  EXTRACTION_PROMPT = <<~PROMPT
    You are an expert accounts payable clerk. Extract all invoice data from this image.

    Return a JSON object with this exact structure:
    {
      "vendor_name": "string or null",
      "vendor_email": "string or null",
      "invoice_number": "string or null",
      "invoice_date": "YYYY-MM-DD or null",
      "due_date": "YYYY-MM-DD or null",
      "total_amount": number or null,
      "line_items": [
        {
          "description": "string",
          "quantity": number or null,
          "unit_price": number or null,
          "amount": number
        }
      ],
      "confidence": number between 0 and 1
    }

    Rules:
    - Return ONLY valid JSON, no markdown, no explanation
    - Use null for any field you cannot determine with confidence
    - confidence reflects overall extraction quality
    - Amounts should be numbers, not strings (no currency symbols)
  PROMPT

  def initialize(invoice)
    @invoice = invoice
    @user = invoice.user
    @client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])
  end

  def extract
    pages = pdf_to_images
    return if pages.empty?

    result = call_gpt4_vision(pages)
    apply_extraction(result)
  rescue => e
    Rails.logger.error "InvoiceExtractorService failed for invoice ##{@invoice.id}: #{e.message}"
    raise
  end

  private

  def pdf_to_images
    return [] unless @invoice.pdf_file.attached?

    pdf_path = download_pdf
    images = []

    MiniMagick::Tool::Convert.new do |convert|
      convert.density(150)
      convert << "#{pdf_path}[0-9]"  # first 10 pages max
      convert.format("png")
      convert.quality(85)
      convert << "#{pdf_path}-%d.png"
    end

    Dir.glob("#{pdf_path}-*.png").sort.first(5).each do |img_path|
      images << Base64.strict_encode64(File.read(img_path))
      File.delete(img_path)
    end

    File.delete(pdf_path) if File.exist?(pdf_path)
    images
  rescue => e
    Rails.logger.warn "PDF conversion failed: #{e.message}"
    []
  end

  def download_pdf
    path = Rails.root.join("tmp", "invoice_#{@invoice.id}_#{SecureRandom.hex(6)}.pdf").to_s
    File.open(path, "wb") { |f| f.write(@invoice.pdf_file.download) }
    path
  end

  def call_gpt4_vision(base64_images)
    image_content = base64_images.map do |b64|
      { type: "image_url", image_url: { url: "data:image/png;base64,#{b64}", detail: "high" } }
    end

    response = @client.chat(
      parameters: {
        model: GPT_MODEL,
        messages: [
          {
            role: "user",
            content: [{ type: "text", text: EXTRACTION_PROMPT }] + image_content
          }
        ],
        max_tokens: 2000,
        temperature: 0
      }
    )

    raw = response.dig("choices", 0, "message", "content").to_s.strip
    JSON.parse(raw)
  rescue JSON::ParserError => e
    Rails.logger.error "GPT-4 Vision returned invalid JSON: #{e.message}"
    {}
  end

  def apply_extraction(data)
    return if data.empty?

    vendor = match_or_create_vendor(data["vendor_name"], data["vendor_email"])

    @invoice.update!(
      vendor: vendor,
      invoice_number: data["invoice_number"],
      invoice_date: parse_date(data["invoice_date"]),
      due_date: parse_date(data["due_date"]),
      total_amount: data["total_amount"],
      confidence_score: data["confidence"],
      raw_text: data.to_json
    )

    create_line_items(data["line_items"] || [])
  end

  def match_or_create_vendor(name, email)
    return nil if name.blank?

    # Fuzzy match against existing vendors
    existing = @user.vendors.pluck(:name, :id)
    matcher = FuzzyMatch.new(existing.map(&:first))
    best_match = matcher.find(name)

    if best_match
      vendor_id = existing.find { |n, _| n == best_match }&.last
      @user.vendors.find_by(id: vendor_id)
    else
      @user.vendors.create!(name: name, email: email)
    end
  end

  def create_line_items(items)
    @invoice.invoice_line_items.destroy_all
    classifier = GlCodeClassifierService.new(@user)

    items.each do |item|
      suggestions = classifier.suggest(item["description"].to_s)
      best = suggestions.first

      @invoice.invoice_line_items.create!(
        description: item["description"],
        quantity: item["quantity"],
        unit_price: item["unit_price"],
        amount: item["amount"],
        gl_code: best&.dig(:gl_code),
        confidence_score: best&.dig(:score)
      )
    end
  end

  def parse_date(str)
    return nil if str.blank?
    Date.parse(str)
  rescue ArgumentError
    nil
  end
end
