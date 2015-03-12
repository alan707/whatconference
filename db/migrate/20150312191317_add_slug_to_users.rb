class AddSlugToUsers < ActiveRecord::Migration
  def change
    add_column :users, :slug, :string, :unique => true
    add_index :users, :slug

    reversible do |dir|
      dir.up do
        set_slug_on_existing_users
      end
    end
  end
  def set_slug_on_existing_users
    User.find_each(&:save)
  end
end
