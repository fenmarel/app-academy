class UsersController < ApplicationController
  before_filter :set_user, only: [:destroy, :show, :update]

  def create
    @user = User.new(user_params)

    if @user.save
      render :json => @user
    else
      render :json => @user.errors.full_messages
    end
  end

  def destroy
    @user.destroy

    render :json => @user
  end

  def index
    @users = User.all

    render :json => @users
  end

  def show
    render :json => @user
  end

  def update
    if @user.update_attributes(user_params)
      render :json => @user
    else
      render :json => @user.errors.full_messages
    end
  end


  private

  def user_params
    params.require(:user).permit(:username)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
