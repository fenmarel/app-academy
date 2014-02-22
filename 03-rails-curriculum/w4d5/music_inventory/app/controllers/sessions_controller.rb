class SessionsController < ApplicationController
  def create
    user = User.find_by_credentials(user_params)

    if user
      login!(user)
      redirect_to user_url(user)
    else
      flash.now[:errors] = "Incorrect Username and/or Password"
      render :new
    end
  end

  def new
    @user = User.new

    render :new
  end

  def destroy
    current_user.reset_session_token!
    session[:session_token] = nil
    redirect_to root_url
  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end

end
