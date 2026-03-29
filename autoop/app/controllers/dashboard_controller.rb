class DashboardController < ApplicationController
  def index
    @vendors_count = current_user.vendors.count
    @invoices_count = current_user.invoices.count
    @pending_invoices = current_user.invoices.where(status: "pending").count
    @quickbooks_connected = current_user.quick_books_connection&.connected?
  end
end
