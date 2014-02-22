class AddTrackNumToTracks < ActiveRecord::Migration
  def change
    add_column(:tracks, :track_number, :integer)
  end
end
