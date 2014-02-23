class Own < ActiveRecord::Base
  validates :album_id, :uniqueness => { :scope => :user_id }
end