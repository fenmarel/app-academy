class AddTypeAndLyricsToTracks < ActiveRecord::Migration
  def change
    add_column(:tracks, :track_type, :string)
    add_column(:tracks, :lyrics, :text)
  end
end
