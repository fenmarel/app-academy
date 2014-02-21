class UsersController < ApplicationController
  before_action :set_user, :only => [:edit, :update, :destroy, :show]
  before_action :confirm_user, :only => [:edit, :update, :destroy]

  def create
    @user = User.new(user_params)

    if @user.save
      login!(@user)
      redirect_to user_url(@user)
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end

  def destroy
    @user.destroy

    redirect_to '/'
  end

  def edit
    render :edit
  end

  def index
    @users = User.all

    render :index
  end

  def new
    @user = User.new

    render :new
  end

  def show
    render :show
  end

  def update
    if @user.update(user_params)
      redirect_to user_url(@user)
    else
      flash.now[:errors] = @user.errors.full_messages
      render :edit
    end
  end


  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def confirm_user
    redirect_to '/' unless current_user == @user
  end
end
