class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :quick_books_connection, dependent: :destroy
  has_many :vendors, dependent: :destroy
  has_many :gl_codes, dependent: :destroy
  has_many :invoices, dependent: :destroy

  validates :company_name, presence: true
end
