class RenameLinksToConferences < ActiveRecord::Migration
  def change
    rename_table :links, :conferences
  end
end
