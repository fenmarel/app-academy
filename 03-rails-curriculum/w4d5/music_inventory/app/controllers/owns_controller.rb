class OwnsController < ApplicationController
  def create
    @album = Album.find(params[:album_id])

    @own = Own.new(user_id: current_user.id, album_id: @album.id)
    @own.save!

    redirect_to album_url(@album)
  end

  def destroy
    @own = Own.find(params[:id])
    @own.destroy

    redirect_to :back
  end
end
