class Vendor < ApplicationRecord
  belongs_to :user
  has_many :invoices, dependent: :nullify

  validates :name, presence: true
  validates :quickbooks_id, uniqueness: { scope: :user_id }, allow_blank: true
end
