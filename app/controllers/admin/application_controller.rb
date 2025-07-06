class Admin::ApplicationController < ApplicationController
  # Add authentication here when needed
  # before_action :authenticate_admin!

  private

  def authenticate_admin!
    # For now, we'll skip authentication
    # In production, add proper admin authentication
  end
end
