# == Schema Information
#
# Table name: friend_circles
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  name       :string(255)      not null
#  created_at :datetime
#  updated_at :datetime
#

class FriendCircle < ActiveRecord::Base
  #:inverse_of => :user
  has_many :friend_circle_memberships,
    :dependent => :destroy,
    :inverse_of => :friend_circle

  has_many(
    :members,
    :through => :friend_circle_memberships,
    :source => :user)

  belongs_to(
    :owner,
    :foreign_key => :user_id,
    :primary_key => :id,
    :class_name => "User")

  validates :owner, :name, :presence => true
end
