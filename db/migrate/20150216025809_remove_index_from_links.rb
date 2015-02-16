class RemoveIndexFromLinks < ActiveRecord::Migration
  def change
  	remove_index :links, :location
    remove_index :links, :start_date
    remove_index :links, :end_date
  end
end
