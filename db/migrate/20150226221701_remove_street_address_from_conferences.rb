class RemoveStreetAddressFromConferences < ActiveRecord::Migration
  def change
    remove_column :conferences, :street_address, :string
  end
end
