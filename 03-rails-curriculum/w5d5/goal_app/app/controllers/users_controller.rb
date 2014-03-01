class UsersController < ApplicationController
  before_filter :ensure_logged_in, :only => [:show]
  before_filter :show_logged_in_user, :only => [:new, :create]

  def new
    @user = User.new

    render :new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      self.current_user = @user
      redirect_to user_url(@user)
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end

  def show
    get_user
    @completed_goals = @user.completed_goals
    @open_goals = @user.open_goals
    @comments = @user.comments

    render :show
  end


  private
  def get_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :password)
  end

  def ensure_logged_in
    unless logged_in?
      flash[:errors] = ["You need to be logged in to view this page"]
      redirect_to new_session_url
    end
  end
end
