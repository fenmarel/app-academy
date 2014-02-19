# == Schema Information
#
# Table name: contacts
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  email      :string(255)      not null
#  user_id    :integer          not null
#  created_at :datetime
#  updated_at :datetime
#  favorite   :boolean
#

class Contact < ActiveRecord::Base
  validates :name, :email, :user_id, presence: true
  validates :email, :uniqueness => true

  has_many(
    :contact_shares,
    :primary_key => :id,
    :foreign_key => :contact_id,
    :class_name => 'ContactShare'
  )

  belongs_to(
    :owner,
    :primary_key => :id,
    :foreign_key => :user_id,
    :class_name => 'User'
  )

  has_many :shared_users, :through => :contact_shares, :source => :user

  has_many(
    :group_joins,
    :primary_key => :id,
    :foreign_key => :contact_id,
    :class_name => "Contact"
  )

  has_many :groups, :through => :group_joins, :source => :group

  def self.contacts_for_user_id(user_id)
    Contact.joins("LEFT OUTER JOIN contact_shares")
           .where("contacts.user_id = #{user_id} OR
                   contact_shares.contact_id = #{user_id}")
  end

  def toggle_fav
    self.favorite = !self.favorite
  end
end
