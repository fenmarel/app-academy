class GoalsController < ApplicationController
  before_filter :verify_goal_owner, :only => [:edit, :update, :destroy]

  def create
    @goal = current_user.goals.new(goal_params)

    if @goal.save
      redirect_to goal_url(@goal)
    else
      flash.now[:errors] = @goal.errors.full_messages
      render :new
    end
  end

  def complete
    get_goal
    @goal.completed = true
    @goal.save!
    redirect_to user_url(current_user)
  end

  def destroy
    get_goal
    @goal.destroy
    redirect_to user_url(current_user)
  end

  def edit
    get_goal
    render :edit
  end

  def new
    @goal = Goal.new
    render :new
  end

  def show
    get_goal
    @comments = @goal.comments
    render :show
  end

  def update
    get_goal

    if @goal.update(goal_params)
      flash[:errors] = ["Goal successfully updated!"]
      redirect_to goal_url(@goal)
    else
      flash.now[:errors] = @goal.errors.full_messages
      render :edit
    end
  end

  private
  def goal_params
    params.require(:goal).permit(:title, :description, :private_goal)
  end

  def get_goal
    @goal = Goal.find(params[:id])
  end

  def verify_goal_owner
    get_goal
    unless current_user == @goal.user
      flash[:errors] = ["You do not have permission to see that page"]
      redirect_to user_url(current_user)
    end
  end

end
