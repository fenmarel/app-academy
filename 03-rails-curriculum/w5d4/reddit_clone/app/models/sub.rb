class Sub < ActiveRecord::Base
  validates :name, :presence => true

  belongs_to(
    :moderator,
    :primary_key => :id,
    :foreign_key => :user_id,
    :class_name => "User"
  )

  has_many :link_subs
  has_many :links, :through => :link_subs
end
