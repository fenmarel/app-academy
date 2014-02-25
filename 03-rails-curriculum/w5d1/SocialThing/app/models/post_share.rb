# == Schema Information
#
# Table name: post_shares
#
#  id               :integer          not null, primary key
#  friend_circle_id :integer
#  post_id          :integer
#  created_at       :datetime
#  updated_at       :datetime
#

class PostShare < ActiveRecord::Base
  belongs_to :post
  belongs_to :friend_circle
end
