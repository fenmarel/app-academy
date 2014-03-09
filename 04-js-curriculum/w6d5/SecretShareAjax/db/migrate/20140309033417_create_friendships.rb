class CreateFriendships < ActiveRecord::Migration
  def change
    create_table :friendships do |t|
      t.integer :follower_id, :null => false
      t.integer :followed_user_id, :null => false

      t.timestamps
    end

    add_index :friendships, :follower_id
    add_index :friendships, :followed_user_id
    add_index :friendships, [:follower_id, :followed_user_id], :unique => true
  end
end
