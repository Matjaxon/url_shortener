class CreateClis < ActiveRecord::Migration
  def change
    create_table :clis do |t|

      t.timestamps null: false
    end
  end
end
