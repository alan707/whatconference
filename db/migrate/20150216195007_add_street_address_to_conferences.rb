class AddStreetAddressToConferences < ActiveRecord::Migration
  def change
    add_column :conferences, :street_address, :string
  end
end
