class AddSlugToConference < ActiveRecord::Migration
  def change
    add_column :conferences, :slug, :string, :unique => true
    add_index :conferences, :slug

    reversible do |dir|
      dir.up do
        set_slug_on_existing_conferences
      end
    end
  end
  def set_slug_on_existing_conferences
    Conference.find_each(&:save)
  end
end
