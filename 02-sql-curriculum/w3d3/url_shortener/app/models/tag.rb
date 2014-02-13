class Tag < ActiveRecord::Base
  validates :topic, :uniqueness => true, :presence => true

  has_many(
    :taggings,
    :primary_key => :id,
    :foreign_key => :tag_id,
    :class_name => "Tagging"
  )

  has_many(
    :shortened_urls,
    :through => :taggings,
    :source => :shortened_url
  )
end