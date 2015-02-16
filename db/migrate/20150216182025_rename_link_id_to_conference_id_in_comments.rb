class RenameLinkIdToConferenceIdInComments < ActiveRecord::Migration
  def change
    rename_column :comments, :link_id, :conference_id
  end
end
