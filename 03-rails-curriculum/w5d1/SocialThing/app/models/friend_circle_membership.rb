# == Schema Information
#
# Table name: friend_circle_memberships
#
#  id               :integer          not null, primary key
#  user_id          :integer          not null
#  friend_circle_id :integer          not null
#  created_at       :datetime
#  updated_at       :datetime
#

class FriendCircleMembership < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend_circle

  validates :user_id, :friend_circle, :presence => true
end
