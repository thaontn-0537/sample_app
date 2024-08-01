class ApplicationController < ActionController::Base
  include SessionsHelper
  include Pagy::Backend

  private

  def logged_in_user
    return if logged_in?

    flash[:danger] = t ".message.log_in"
    store_location
    redirect_to login_url
  end
end
