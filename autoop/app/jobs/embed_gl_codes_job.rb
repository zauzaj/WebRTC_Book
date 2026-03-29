class EmbedGlCodesJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)
    GlCodeClassifierService.embed_gl_codes(user)
    Rails.logger.info "EmbedGlCodesJob: embedded GL codes for user ##{user_id}"
  rescue ActiveRecord::RecordNotFound
    Rails.logger.warn "EmbedGlCodesJob: user ##{user_id} not found"
  end
end
