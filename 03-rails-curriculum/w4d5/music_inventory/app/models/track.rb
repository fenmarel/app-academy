class Track < ActiveRecord::Base
  belongs_to :album

  TRACK_TYPES = ['Normal', 'Live', 'Bonus']
end