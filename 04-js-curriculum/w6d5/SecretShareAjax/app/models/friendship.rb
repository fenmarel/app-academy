class Friendship < ActiveRecord::Base
  belongs_to(
    :follower,
    :class_name => "User",
    :foreign_key => :follower_id
  )

  belongs_to(
    :followed_user,
    :class_name => "User",
    :foreign_key => :followed_user_id
  )


  def self.find_id_by_users(follower, followed)
    @friendship = Friendship.where(follower_id: follower.id, followed_user_id: followed.id)

    @friendship.exists? ? @friendship.first.id : nil
  end

  def self.can_friend?(follower, followed)
    Friendship.where(follower_id: follower.id, followed_user_id: followed.id).empty? &&
    follower != followed
  end

  def self.can_unfriend?(follower, followed)
    Friendship.where(follower_id: follower.id, followed_user_id: followed.id).exists? &&
    follower != followed
  end
end
