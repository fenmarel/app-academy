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


  def self.can_friend?(follower, followed)
    Friendship.where(follower_id: follower.id, followed_user_id: followed.id).empty? &&
    follower != followed
  end
end
