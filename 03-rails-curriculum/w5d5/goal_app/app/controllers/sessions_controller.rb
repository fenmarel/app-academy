class SessionsController < ApplicationController
  before_filter :show_logged_in_user, :only => [:new, :create]

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.find_by_credentials(user_params)

    if @user.nil?
      flash.now[:errors] = ["Invalid credentials"]
      render :new
    else
      self.current_user = @user
      redirect_to user_url(@user)
    end
  end

  def destroy
    logout!
    redirect_to new_session_url
  end


  private

  def user_params
    params.require(:user).permit(:username, :password)
  end

end
