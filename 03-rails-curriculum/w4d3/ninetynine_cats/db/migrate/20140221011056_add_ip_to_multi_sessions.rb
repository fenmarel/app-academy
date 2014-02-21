class AddIpToMultiSessions < ActiveRecord::Migration
  def change
    add_column(:multi_sessions, :ip_address, :string)
  end
end
