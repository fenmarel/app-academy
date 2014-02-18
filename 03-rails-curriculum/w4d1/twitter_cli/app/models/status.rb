require 'json'
require 'open-uri'


class Status < ActiveRecord::Base
  validates :twitter_status_id, :uniqueness => true
  validates :body, :length => { maximum: 140 }

  belongs_to(
    :user,
    :primary_key => :twitter_user_id,
    :foreign_key => :twitter_user_id,
    :class_name => "User"
  )

  def self.get_tweets_by_user_id(id)
    if self.connected_to_internet?
      self.fetch_by_user_id!(id)
    end

    Status.select("*").where(:twitter_user_id => id)
  end

  def self.post(body)
    status = "[#{TwitterSession.post("/statuses/update", status: body)}]"

    if status.include?("Status is a duplicate")
      puts "Status is a duplicate! Unable to post!"
    else
      self.parse_json(status)
    end
  end

  def self.fetch_by_user_id!(id)
    statuses = TwitterSession.get("/statuses/user_timeline", user_id: id)

    self.parse_json(statuses)
  end


  private

  def self.connected_to_internet?
    begin
      true if open("http://www.google.com/")
    rescue
      false
    end
  end

  def self.parse_json(statuses)
    statuses = JSON.parse(statuses)

    status_list = []
    user_id = nil

    statuses.each do |status|
      body = status["text"]
      stat_id = status["id"]
      user_id = status["user"]["id_str"]

      status_list << Status.new(body: body,
                                twitter_status_id: stat_id,
                                twitter_user_id: user_id)
    end

    old_ids = Status.where(:twitter_user_id => user_id)
                    .pluck(:twitter_status_id).map(&:to_i)

    status_list.each do |status|
      unless old_ids.include?(status.twitter_status_id)
        status.save!
      end
    end
  end
end
