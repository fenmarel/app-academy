class FriendCirclesController < ApplicationController

  def new
    @user = User.find(params[:user_id])
    @friend_circle = FriendCircle.new
    render :new
  end

  def create
    @user = User.find(params[:user_id])
    @friend_circle = FriendCircle.new(friend_circle_params)

    if @friend_circle.save
      redirect_to user_url(@user)
    else
      flash.now[:errors] = @friend_circle.errors.full_messages
      render :new
    end
  end

  def edit
    @friend_circle = FriendCircle.find(params[:id])
    @user = @friend_circle.owner
    @members = @friend_circle.members

    render :edit
  end

  def update
    @friend_circle = FriendCircle.find(params[:id])

    if @friend_circle.update_attributes(friend_circle_params)
      redirect_to user_url(@friend_circle.owner)
    else
      flash.now[:errors] = @friend_circle.errors.full_messages
      render :edit
    end
  end

  private

  def friend_circle_params
    params.require(:friend_circle).permit(:name, :user_id, :member_ids => [])
  end
end
