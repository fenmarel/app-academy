class CreateUser < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :screen_name
      t.string :twitter_user_id
    end

    add_index :users, :screen_name, unique: true
    add_index :users, :twitter_user_id, unique: true
  end
end
