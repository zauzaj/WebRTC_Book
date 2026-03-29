class GlCodeClassifierService
  SIMILARITY_THRESHOLD = 0.75
  TOP_K = 5

  def initialize(user)
    @user = user
  end

  # Returns an array of { gl_code:, score: } suggestions for a line item description
  def suggest(description)
    return [] if description.blank?

    embedding = EmbeddingService.embed(description)
    return [] unless embedding

    results = @user.gl_codes
      .where.not(embedding: nil)
      .nearest_neighbors(:embedding, embedding, distance: "cosine")
      .limit(TOP_K)
      .map { |gl| { gl_code: gl, score: gl.neighbor_distance ? (1 - gl.neighbor_distance).round(4) : 0 } }
      .select { |r| r[:score] >= SIMILARITY_THRESHOLD }

    results
  end

  # Returns the single best GL code or nil
  def classify(description)
    suggestions = suggest(description)
    suggestions.first&.dig(:gl_code)
  end

  # Embed all GL codes for the user (run after QB sync)
  def self.embed_gl_codes(user)
    service = EmbeddingService.new
    user.gl_codes.find_each do |gl|
      text = [gl.name, gl.account_type, gl.account_number].compact.join(" ")
      embedding = service.embed(text)
      gl.update_column(:embedding, embedding) if embedding
    end
  end
end
