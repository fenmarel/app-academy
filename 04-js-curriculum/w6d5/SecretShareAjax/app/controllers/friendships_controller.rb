class FriendshipsController < ApplicationController
  def create
    @friendship = Friendship.new(friendship_params)

    respond_to do |format|
      if @friendship.save
        format.html { redirect_to users_url }
        format.json { render :json => @friendship }
      else
        format.html do
          flash.now[:errors] = @friendship.errors.full_messages
          redirect_to users_url
        end

        format.json { render :json => @friendship.errors, status: 422 }
      end
    end
  end

  def destroy
    @friendship = Friendship.where(friendship_params).first
    @friendship && @friendship.destroy!

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { render :json => @friendship }
    end
  end


  private

  def friendship_params
    { :follower_id => current_user.id, :followed_user_id => params[:user_id] }
  end
end
