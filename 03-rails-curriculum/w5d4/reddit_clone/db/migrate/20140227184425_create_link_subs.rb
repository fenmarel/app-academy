class CreateLinkSubs < ActiveRecord::Migration
  def change
    create_table :link_subs do |t|
      t.references :link
      t.references :sub

      t.timestamps
    end
  end
end
