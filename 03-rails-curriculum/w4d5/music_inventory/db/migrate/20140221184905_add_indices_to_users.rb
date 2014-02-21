class AddIndicesToUsers < ActiveRecord::Migration
  def change
    add_index(:users, :username)
    add_index(:users, :session_token)
  end
end
