class EmbeddingService
  MODEL = "text-embedding-3-small"
  DIMENSIONS = 1536

  def initialize
    @client = OpenAI::Client.new
  end

  def embed(text)
    return nil if text.blank?

    response = @client.embeddings(
      parameters: { model: MODEL, input: text.truncate(8000) }
    )
    response.dig("data", 0, "embedding")
  rescue => e
    Rails.logger.error "EmbeddingService failed: #{e.message}"
    nil
  end

  def self.embed(text)
    new.embed(text)
  end
end
