class QuickbooksSyncController < ApplicationController
  def create
    QuickbooksSyncJob.perform_later(current_user.id)
    redirect_to dashboard_path, notice: "Sync started! Vendors and GL codes will update shortly."
  end
end
