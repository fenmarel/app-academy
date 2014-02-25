class SessionsController < ApplicationController
  def new
    @user = User.new

    render :new
  end

  def create
    @user= User.find_by_credentials(params[:user][:email], params[:user][:password])

    if @user
      login!(@user)
      redirect_to user_url(@user)
    else
      flash.now[:errors] = "Invalid Login"
      render :new
    end
  end

  def destroy
    logout

    redirect_to new_session_url
  end

  def new_password_reset
    @user = User.new

    render :new_password_reset
  end

  def send_password_reset
    @user = User.find_by_email(params[:email])

    msg = UserMailer.password_reset(@user)
    msg.deliver!

    flash[:errors] = "Email sent"
    redirect_to new_session_url
  end

end
