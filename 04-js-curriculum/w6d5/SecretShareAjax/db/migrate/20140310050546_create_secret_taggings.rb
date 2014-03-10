class CreateSecretTaggings < ActiveRecord::Migration
  def change
    create_table :secret_taggings do |t|
      t.references :tag, :null => false
      t.references :secret, :null => false

      t.timestamps
    end

    add_index :secret_taggings, :tag_id
    add_index :secret_taggings, :secret_id
    add_index :secret_taggings, [:tag_id, :secret_id], :unique => true
  end
end
