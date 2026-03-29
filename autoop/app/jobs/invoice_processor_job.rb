class InvoiceProcessorJob < ApplicationJob
  queue_as :default

  def perform(invoice_id)
    invoice = Invoice.find(invoice_id)
    invoice.update!(status: "processing")

    InvoiceExtractorService.new(invoice).extract

    invoice.update!(status: "reviewed")
  rescue ActiveRecord::RecordNotFound
    Rails.logger.warn "InvoiceProcessorJob: invoice ##{invoice_id} not found"
  rescue => e
    invoice&.update!(status: "failed", notes: "Processing error: #{e.message}")
    Rails.logger.error "InvoiceProcessorJob error for ##{invoice_id}: #{e.message}"
    raise
  end
end
