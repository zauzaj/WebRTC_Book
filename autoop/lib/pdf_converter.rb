module PdfConverter
  # Converts a PDF blob (binary string) into an array of Base64-encoded PNG strings,
  # one per page (up to max_pages).
  def self.to_base64_images(pdf_binary, max_pages: 5)
    tmp = Tempfile.new(["invoice", ".pdf"], binmode: true)
    tmp.write(pdf_binary)
    tmp.flush

    images = []
    MiniMagick::Tool::Convert.new do |convert|
      convert.density(150)
      convert << "#{tmp.path}[0-#{max_pages - 1}]"
      convert.format("png")
      convert.quality(85)
      convert << "#{tmp.path}-%d.png"
    end

    Dir.glob("#{tmp.path}-*.png").sort.first(max_pages).each do |path|
      images << Base64.strict_encode64(File.binread(path))
      File.delete(path)
    end

    images
  ensure
    tmp&.close
    tmp&.unlink
  end
end
