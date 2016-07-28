class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.timestamps
      t.text :email

    end
    add_index :users, :email
  end
end
