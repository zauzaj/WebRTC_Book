class GlCode < ApplicationRecord
  belongs_to :user
  has_many :invoice_line_items, dependent: :nullify

  validates :name, presence: true
  validates :quickbooks_id, uniqueness: { scope: :user_id }, allow_blank: true
end
