class ShortenedUrl < ActiveRecord::Base
  validates :short_url, :uniqueness => true, :presence => true
  validates :long_url, :presence => true

  belongs_to(
    :submitter,
    :class_name => "User",
    :foreign_key => :user_id,
    :primary_key => :id
  )

  has_many(
    :visits,
    :primary_key => :id,
    :foreign_key => :shortened_url_id,
    :class_name => "Visit"
  )

  has_many(
    :visitors, -> { uniq },
    :through => :visits,
    :source => :user
  )

  has_many(
    :taggings,
    :primary_key => :id,
    :foreign_key => :shortened_url_id,
    :class_name => "Tagging"
  )

  has_many(
    :tags,
    :through => :taggings,
    :source => :tag
  )


  def self.create_for_user_and_long_url!(user, long_url)
    ShortenedUrl.create!(:long_url => long_url,
                         :user_id => user.id,
                         :short_url => self.random_code)
  end

  def self.random_code
    random = SecureRandom::urlsafe_base64(12)

    until ShortenedUrl.find_by_short_url(random).nil?
      random = SecureRandom::urlsafe_base64(12)
    end

    random
  end


  def num_clicks
    self.visits.count
  end

  def num_uniques
    Visit.where("shortened_url_id = ?", self.id).distinct.count(:user_id)
  end

  def num_recent_uniques
    Visit.where("shortened_url_id = ? AND created_at > ?",
                self.id, 10.minutes.ago).distinct.count(:user_id)
  end
end