module SessionsHelper

  def check_if_logged_in!
    redirect_to root_url if logged_in?
  end

  def logged_in?
    !!current_user
  end

  def login_on_device!(user, device)
    session[:session_token] = user.reset_session_token_for_device!(device)
  end

  def current_user
    multisession = MultiSession.find_by_session_token(session[:session_token])

    unless multisession.nil?
      User.find(multisession.user_id)
    else
      nil
    end
  end

end
