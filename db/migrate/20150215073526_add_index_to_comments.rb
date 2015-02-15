class AddIndexToComments < ActiveRecord::Migration
  def change
    add_index :comments, :link_id
  end
end
