module QuickbooksTokenRefreshable
  TOKEN_URL = "https://oauth.platform.intuit.com/oauth2/v1/tokens/bearer"

  def fresh_access_token
    refresh_tokens! if token_expired?
    access_token
  end

  def refresh_tokens!
    response = HTTParty.post(TOKEN_URL,
      headers: {
        "Authorization" => "Basic #{Base64.strict_encode64("#{ENV['QB_CLIENT_ID']}:#{ENV['QB_CLIENT_SECRET']}")}",
        "Content-Type" => "application/x-www-form-urlencoded"
      },
      body: {
        grant_type: "refresh_token",
        refresh_token: refresh_token
      }
    )

    if response.success?
      data = JSON.parse(response.body)
      update!(
        access_token: data["access_token"],
        refresh_token: data["refresh_token"],
        token_expires_at: Time.current + data["expires_in"].to_i.seconds
      )
    else
      update!(connected: false)
      raise "QuickBooks token refresh failed"
    end
  end
end
