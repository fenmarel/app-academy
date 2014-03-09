class FriendshipsController < ApplicationController
  def create
    @friendship = Friendship.new(friendship_params)

    if @friendship.save
      redirect_to users_url
    else
      flash.now[:errors] = @friendship.errors.full_messages
      redirect_to users_url
    end
  end


  private

  def friendship_params
    { :follower_id => current_user.id, :followed_user_id => params[:user_id] }
  end
end
