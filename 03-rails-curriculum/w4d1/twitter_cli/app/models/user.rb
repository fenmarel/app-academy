require 'json'


class User < ActiveRecord::Base
  has_many(
    :tweets,
    :primary_key => :twitter_user_id,
    :foreign_key => :twitter_user_id,
    :class_name => "Status"
  )

  def self.get_by_screen_name(name)
    user = User.find_by_screen_name(name)

    unless user
      user = self.fetch_by_screen_name!(name)
    end
  end

  def fetch_statuses!
    Status.fetch_by_user_id!(self.twitter_user_id)
  end


  private

  def self.fetch_by_screen_name!(name)
    user = TwitterSession.get('/users/show', screen_name: name)

    self.parse_twitter_user(user)
  end

  def self.parse_twitter_user(user)
    user = JSON.parse(user)

    screen_name = user["screen_name"]
    id_str = user["id_str"]

    User.create!(screen_name: screen_name, twitter_user_id: id_str)
  end
end