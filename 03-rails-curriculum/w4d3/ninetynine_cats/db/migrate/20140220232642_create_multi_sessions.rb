class CreateMultiSessions < ActiveRecord::Migration
  def change
    create_table :multi_sessions do |t|
      t.integer :user_id
      t.string :session_token, unique: true
      t.string :device
    end

    add_index :multi_sessions, :user_id
    add_index :multi_sessions, :session_token
  end
end
