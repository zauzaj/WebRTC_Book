class QuickbooksSyncJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)
    result = QuickbooksSyncService.new(user).sync_all

    Rails.logger.info "QB sync for user #{user_id}: #{result.inspect}"
  rescue ActiveRecord::RecordNotFound
    Rails.logger.warn "QuickbooksSyncJob: user #{user_id} not found"
  end
end
