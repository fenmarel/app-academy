class Comment < ActiveRecord::Base
  validates :body, :presence => true

  belongs_to :link
  belongs_to :user

  has_many(
    :replies,
    :primary_key => :id,
    :foreign_key => :parent_comment_id,
    :class_name => "Comment"
  )
end
