class InvoicesMailbox < ActionMailbox::Base
  def process
    user = find_user_from_email
    return bounce_with_not_found unless user

    invoice = create_invoice(user)
    attach_pdf(invoice)
    queue_processing(invoice)

    Rails.logger.info "InvoicesMailbox: created invoice ##{invoice.id} for user ##{user.id}"
  end

  private

  def find_user_from_email
    # Match by the To: address subdomain or by registered user email
    recipient = mail.recipients.first.to_s
    if (match = recipient.match(/\+(.+)@/))
      User.find_by(id: match[1])
    else
      User.find_by(email: mail.from.first)
    end
  end

  def create_invoice(user)
    user.invoices.create!(
      status: "pending",
      notes: "Received via email from #{mail.from.first} — Subject: #{mail.subject}"
    )
  end

  def attach_pdf(invoice)
    # Prefer explicit PDF attachments
    pdf_part = mail.attachments.find { |a| a.content_type.include?("pdf") }

    if pdf_part
      invoice.pdf_file.attach(
        io: StringIO.new(pdf_part.decoded),
        filename: pdf_part.filename.presence || "invoice.pdf",
        content_type: "application/pdf"
      )
    elsif mail.body.decoded.present?
      # Store raw email body as fallback
      invoice.update!(raw_text: mail.body.decoded)
    end
  end

  def queue_processing(invoice)
    InvoiceProcessorJob.perform_later(invoice.id)
  end

  def bounce_with_not_found
    Rails.logger.warn "InvoicesMailbox: no user found for #{mail.from.first}"
  end
end
