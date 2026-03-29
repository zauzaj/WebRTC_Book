class QuickbooksAuthController < ApplicationController
  AUTHORIZATION_URL = "https://appcenter.intuit.com/connect/oauth2"
  TOKEN_URL = "https://oauth.platform.intuit.com/oauth2/v1/tokens/bearer"
  SCOPE = "com.intuit.quickbooks.accounting"

  def connect
    redirect_to authorization_url, allow_other_host: true
  end

  def callback
    if params[:error].present?
      redirect_to dashboard_path, alert: "QuickBooks connection failed: #{params[:error]}"
      return
    end

    token_response = exchange_code_for_tokens(params[:code])

    if token_response.success?
      data = JSON.parse(token_response.body)
      save_connection(data, params[:realmId])
      redirect_to dashboard_path, notice: "QuickBooks connected successfully!"
    else
      redirect_to dashboard_path, alert: "Failed to connect QuickBooks. Please try again."
    end
  end

  def disconnect
    current_user.quick_books_connection&.destroy
    redirect_to dashboard_path, notice: "QuickBooks disconnected."
  end

  private

  def authorization_url
    params = {
      client_id: ENV["QB_CLIENT_ID"],
      redirect_uri: ENV["QB_REDIRECT_URI"],
      response_type: "code",
      scope: SCOPE,
      state: SecureRandom.hex(16)
    }
    "#{AUTHORIZATION_URL}?#{params.to_query}"
  end

  def exchange_code_for_tokens(code)
    HTTParty.post(TOKEN_URL,
      headers: {
        "Authorization" => "Basic #{Base64.strict_encode64("#{ENV['QB_CLIENT_ID']}:#{ENV['QB_CLIENT_SECRET']}")}",
        "Content-Type" => "application/x-www-form-urlencoded"
      },
      body: {
        grant_type: "authorization_code",
        code: code,
        redirect_uri: ENV["QB_REDIRECT_URI"]
      }
    )
  end

  def save_connection(data, realm_id)
    connection = current_user.quick_books_connection || current_user.build_quick_books_connection
    connection.update!(
      access_token: data["access_token"],
      refresh_token: data["refresh_token"],
      token_expires_at: Time.current + data["expires_in"].to_i.seconds,
      realm_id: realm_id,
      connected: true
    )
  end
end
