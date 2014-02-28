class LinkSub < ActiveRecord::Base
  validates :link_id, :sub_id, :presence => true

  belongs_to :sub
  belongs_to :link
end
