class UsersController < ApplicationController
  before_filter :set_user, :only => [:show, :update, :destroy]

  def index
    @users = User.all
    render :json => @users
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render :json => @user, :status => 200
    else
      render :json => @user.errors.full_messages, :status => 422
    end
  end

  def show
    render :json => @user, :status => 200
  end

  def update
    @user.update_attributes(user_params)
    redirect_to users_url(@user)
  end

  def destroy
    @user.destroy!
    render :json => @user
  end


  private

  def user_params
    params.require(:user).permit(:name, :email)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
