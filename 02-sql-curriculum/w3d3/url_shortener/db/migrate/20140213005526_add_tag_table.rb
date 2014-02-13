class AddTagTable < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :topic
    end

    create_table :taggings do |t|
      t.integer :tag_id
      t.integer :shortened_url_id
    end
  end
end
