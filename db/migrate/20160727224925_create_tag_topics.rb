class CreateTagTopics < ActiveRecord::Migration
  def change
    create_table :tag_topics do |t|
      t.string :tag, null: false

      t.timestamps null: false
    end
    add_index :tag_topics, :tag
  end
end
