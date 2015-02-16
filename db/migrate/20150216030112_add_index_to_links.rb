class AddIndexToLinks < ActiveRecord::Migration
  def change
  	add_index :links, :location
    add_index :links, :start_date
    add_index :links, :end_date
  end
end
