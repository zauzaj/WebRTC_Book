class Invoice < ApplicationRecord
  belongs_to :user
  belongs_to :vendor, optional: true
  has_many :invoice_line_items, dependent: :destroy
  has_one_attached :pdf_file

  STATUSES = %w[pending processing reviewed approved posted failed].freeze

  validates :status, inclusion: { in: STATUSES }

  after_initialize { self.status ||= "pending" }

  def approved?
    status == "approved"
  end

  def posted?
    status == "posted"
  end
end
