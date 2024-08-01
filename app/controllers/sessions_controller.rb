class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params.dig(:session, :email)&.downcase
    if user.try(:authenticate, params.dig(:session, :password))
      if user.activated
        forwarding_url = session[:forwarding_url]
        reset_session
        log_in user
        if params.dig(:session,
                      :remember_me) == "1"
          remember(user)
        else
          forget(user)
        end
        redirect_to forwarding_url || user
      else
        flash[:warning] = t ".message.not_activated"
        redirect_to root_url, status: :see_other
      end
    else
      flash.now[:danger] = t ".message.invalid_email_password_combination"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    log_out
    redirect_to root_url, status: :see_other
  end
end
