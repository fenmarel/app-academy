class SessionsController < ApplicationController
  before_action :check_if_logged_in!, only: [:new, :create]

  def new
    @user = User.new

    render :new
  end

  def create
    @user = User.find_by_credentials(user_params)

    if @user
      login_on_device!(@user, params[:multi_session])
      redirect_to root_url
    else
      flash.now[:errors] = ["Incorrect user name and/or password"]
      render :new
    end
  end

  def destroy
    MultiSession.find_by_session_token(session[:session_token]).destroy
    session[:session_token] = nil

    redirect_to new_session_url
  end

  private

  def user_params
    params.require(:user).permit(:user_name, :password)
  end

end
