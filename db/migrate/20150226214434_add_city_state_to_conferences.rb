class AddCityStateToConferences < ActiveRecord::Migration
  def change
    add_column :conferences, :city_state, :string
  end
end
