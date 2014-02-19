# == Schema Information
#
# Table name: groups
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Group < ActiveRecord::Base
  belongs_to(
    :user,
    :primary_key => :id,
    :foreign_key => :user_id,
    :class_name => "User"
  )

  has_many(
    :group_joins,
    :primary_key => :id,
    :foreign_key => :group_id,
    :class_name => 'GroupJoin',
    :dependent => :destroy
  )

  has_many :contacts, :through => :group_joins, :source => :contact

  def self.groups_for_user_id(user_id)
    Group.joins(:users).where(user_id: user_id)
  end

  def self.get_members_of_group(group_id)
    GroupJoin.joins(:contact).where(group_id: group_id)
  end
end
