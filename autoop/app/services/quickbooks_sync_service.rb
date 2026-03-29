class QuickbooksSyncService
  BASE_URL = "https://quickbooks.api.intuit.com/v3/company"

  def initialize(user)
    @user = user
    @connection = user.quick_books_connection
  end

  def sync_all
    return { success: false, error: "No QuickBooks connection" } unless @connection&.connected?

    vendor_result = sync_vendors
    gl_result = sync_gl_codes

    {
      success: true,
      vendors_synced: vendor_result[:count],
      gl_codes_synced: gl_result[:count]
    }
  rescue => e
    { success: false, error: e.message }
  end

  def sync_vendors
    vendors = fetch_all("Vendor", %w[Id DisplayName PrimaryEmailAddr PrimaryPhone BillAddr])
    count = 0

    vendors.each do |qb_vendor|
      @user.vendors.find_or_initialize_by(quickbooks_id: qb_vendor["Id"]).tap do |vendor|
        vendor.update!(
          name: qb_vendor["DisplayName"],
          email: qb_vendor.dig("PrimaryEmailAddr", "Address"),
          phone: qb_vendor.dig("PrimaryPhone", "FreeFormNumber"),
          address: format_address(qb_vendor["BillAddr"])
        )
        count += 1
      end
    end

    { count: count }
  end

  def sync_gl_codes
    accounts = fetch_all("Account", %w[Id Name AccountType AccountSubType AcctNum])
    count = 0

    accounts.each do |account|
      @user.gl_codes.find_or_initialize_by(quickbooks_id: account["Id"]).tap do |gl|
        gl.update!(
          name: account["Name"],
          account_type: account["AccountType"],
          account_number: account["AcctNum"]
        )
        count += 1
      end
    end

    { count: count }
  end

  private

  def fetch_all(entity, fields)
    token = @connection.fresh_access_token
    field_list = fields.join(", ")
    query = "SELECT #{field_list} FROM #{entity} WHERE Active = true MAXRESULTS 1000"
    url = "#{BASE_URL}/#{@connection.realm_id}/query?query=#{CGI.escape(query)}&minorversion=65"

    response = HTTParty.get(url,
      headers: {
        "Authorization" => "Bearer #{token}",
        "Accept" => "application/json"
      }
    )

    raise "QuickBooks API error: #{response.code}" unless response.success?

    data = JSON.parse(response.body)
    data.dig("QueryResponse", entity) || []
  end

  def format_address(addr)
    return nil unless addr
    [ addr["Line1"], addr["City"], addr["CountrySubDivisionCode"], addr["PostalCode"] ]
      .compact.join(", ")
  end
end
