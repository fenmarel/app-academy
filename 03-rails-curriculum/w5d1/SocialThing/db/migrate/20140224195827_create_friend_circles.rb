class CreateFriendCircles < ActiveRecord::Migration
  def change
    create_table :friend_circles do |t|
      t.integer :user_id, :null => false
      t.string :name, :null => false

      t.timestamps
    end

    add_index :friend_circles, :user_id

    create_table :friend_circle_memberships do |t|
      t.integer :user_id, :null => false
      t.integer :friend_circle_id, :null => false

      t.timestamps
    end

    add_index :friend_circle_memberships, :user_id
    add_index :friend_circle_memberships, :friend_circle_id
  end
end

