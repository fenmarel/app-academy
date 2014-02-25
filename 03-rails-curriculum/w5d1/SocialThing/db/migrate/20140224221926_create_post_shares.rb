class CreatePostShares < ActiveRecord::Migration
  def change
    create_table :post_shares do |t|
      t.integer :friend_circle_id
      t.integer :post_id

      t.timestamps
    end

    add_index :post_shares, :friend_circle_id
    add_index :post_shares, :post_id
  end
end
