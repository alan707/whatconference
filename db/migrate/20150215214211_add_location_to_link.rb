class AddLocationToLink < ActiveRecord::Migration
  def change
    add_column :links, :location, :string
    add_index :links, :location
    add_column :links, :start_date, :date
    add_index :links, :start_date
    add_column :links, :end_date, :date
    add_index :links, :end_date
  end
end
