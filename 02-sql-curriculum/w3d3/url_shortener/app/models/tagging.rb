class Tagging < ActiveRecord::Base
  validates :tag_id, :presence => true,
                     :uniqueness => { :scope => :shortened_url_id }
  validates :shortened_url_id, :presence => true

  belongs_to(
    :tag,
    :primary_key => :id,
    :foreign_key => :tag_id,
    :class_name => "Tag"
  )

  belongs_to(
    :shortened_url,
    :primary_key => :id,
    :foreign_key => :shortened_url_id,
    :class_name => "ShortenedUrl"
  )
end