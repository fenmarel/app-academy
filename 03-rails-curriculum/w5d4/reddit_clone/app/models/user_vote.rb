class UserVote < ActiveRecord::Base
  validates :user_id, :uniqueness => { :scope => :link_id }
end