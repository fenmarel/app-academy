module SessionsHelper
  def login!(user)
    if user.activated
      session[:session_token] = user.reset_session_token!
    else
      flash[:errors] = "Activation email has been sent.  Please Activate Your Account to Proceed"
    end
  end

  def current_user
    User.find_by_session_token(session[:session_token])
  end

  def logged_in?
    !!current_user
  end
end
