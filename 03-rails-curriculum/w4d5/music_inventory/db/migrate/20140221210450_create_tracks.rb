class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.string :title
      t.references :album
    end

    add_index(:tracks, :album_id)
  end
end
