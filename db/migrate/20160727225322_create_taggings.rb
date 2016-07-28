class CreateTaggings < ActiveRecord::Migration
  def change
    create_table :taggings do |t|
      t.integer :tag_id, null: false
      t.integer :shortened_url_id, null: false

      t.timestamps null: false
    end
    add_index :taggings, :tag_id
    add_index :taggings, :shortened_url_id
  end
end
