class CreateBands < ActiveRecord::Migration
  def change
    create_table :bands do |t|
      t.string :name, :unique => true, :null => false
    end

    add_index(:bands, :name)
  end
end
