class AddResetTokenColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :reset_token, :string
  end
end
