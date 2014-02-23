class CreateOwns < ActiveRecord::Migration
  def change
    create_table :owns do |t|
      t.references :album, :null => false
      t.references :user, :null => false
    end

    add_index(:owns, :album_id)
    add_index(:owns, :user_id)
  end
end
