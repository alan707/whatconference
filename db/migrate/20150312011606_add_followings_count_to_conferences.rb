class AddFollowingsCountToConferences < ActiveRecord::Migration
  def change
    add_column :conferences, :followings_count, :integer
    
    reversible do |dir|
      dir.up do
        Conference.reset_column_information

        Conference.find_each do |conference|
          Conference.reset_counters conference.id, :followings
        end
      end
    end
  end
end
