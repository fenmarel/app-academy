class UsersController < ApplicationController
  before_action :check_if_logged_in!, only: [:new, :create]

  def new
    @user = User.new

    render :new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      login_on_device!(@user, params[:multi_session])
      redirect_to root_url
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end


  private

  def user_params
    params.require(:user).permit(:user_name, :password)
  end
end
