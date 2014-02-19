# == Schema Information
#
# Table name: group_joins
#
#  id         :integer          not null, primary key
#  group_id   :integer
#  contact_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class GroupJoin < ActiveRecord::Base
  belongs_to(
    :group,
    :primary_key => :id,
    :foreign_key => :group_id,
    :class_name => 'Group'
  )

  belongs_to(
    :contact,
    :primary_key => :id,
    :foreign_key => :contact_id,
    :class_name => "Contact"
  )
end
