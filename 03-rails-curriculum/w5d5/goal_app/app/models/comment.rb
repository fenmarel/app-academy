class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true
  belongs_to(
    :author,
    :primary_key => :id,
    :foreign_key => :user_id,
    :class_name => "User",
    :inverse_of => :authored_comments)

  validates :body, :presence => true

end
