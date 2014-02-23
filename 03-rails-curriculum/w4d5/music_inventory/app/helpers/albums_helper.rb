module AlbumsHelper
  def current_own(album)
    Own.where("user_id = #{current_user.id} AND album_id = #{album.id}").first
  end

  def current_user_owns?(album)
    !current_own(album).nil?
  end
end
