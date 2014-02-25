# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  body       :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Post < ActiveRecord::Base
  validates :body, :presence => true

  has_many :links, :inverse_of => :post, :dependent => :destroy
  has_many :post_shares, :inverse_of => :post, :dependent => :destroy
  belongs_to(
    :author,
    :foreign_key => :user_id,
    :primary_key => :id,
    :class_name => "User"
  )

  has_many(
    :friend_circles,
    :through => :post_shares,
    :source => :friend_circle
  )
end
