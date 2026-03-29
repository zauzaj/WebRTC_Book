class QuickBooksConnection < ApplicationRecord
  include QuickbooksTokenRefreshable

  belongs_to :user

  validates :realm_id, presence: true
  validates :access_token, presence: true

  def token_expired?
    token_expires_at.present? && token_expires_at <= Time.current
  end
end
