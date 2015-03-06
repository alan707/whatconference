class CreateFollowings < ActiveRecord::Migration
  def change
    create_table :followings do |t|
      t.integer :conference_id, null: false
      t.integer :user_id, null: false

      t.timestamps null: false
    end

    add_index :followings, :user_id,       :unique => true
    add_index :followings, :conference_id, :unique => true
  end
end
