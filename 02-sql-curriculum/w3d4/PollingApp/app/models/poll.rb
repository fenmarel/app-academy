class Poll < ActiveRecord::Base
  validates :title, :presence => true
  validates :user_id, :presence => true

  belongs_to(
    :user,
    :class_name => "User",
    :primary_key => :id,
    :foreign_key => :user_id
  )

  has_many(
    :questions,
    :class_name => "Question",
    :primary_key => :id,
    :foreign_key => :poll_id,
    :dependent => :destroy
  )
end