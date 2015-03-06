class RenameUserIdToCreationUserIdInConferences < ActiveRecord::Migration
  def change
    rename_column :conferences, :user_id, :creation_user_id
  end
end
