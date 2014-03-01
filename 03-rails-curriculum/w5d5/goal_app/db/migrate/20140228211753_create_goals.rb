class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.integer :user_id, null: false
      t.string :title, null: false
      t.text :description, null: false
      t.boolean :completed, null: false, default: false
      t.boolean :private_goal, null: false, default: false

      t.timestamps
    end
    add_index :goals, :user_id
    add_index :goals, :completed
    add_index :goals, :private_goal
  end
end
