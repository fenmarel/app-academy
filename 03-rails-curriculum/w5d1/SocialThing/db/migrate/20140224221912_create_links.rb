class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.integer :post_id
      t.string :url

      t.timestamps
    end

    add_index :links, :post_id
  end
end
