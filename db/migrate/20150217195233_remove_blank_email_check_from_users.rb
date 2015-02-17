class RemoveBlankEmailCheckFromUsers < ActiveRecord::Migration
  def change
    change_column_null :users, :email, true

    remove_column :users, :encrypted_password
    remove_column :users, :reset_password_token
    remove_column :users, :reset_password_sent_at
  end
end
