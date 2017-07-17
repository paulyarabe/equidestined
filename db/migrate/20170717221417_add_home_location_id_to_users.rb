class AddHomeLocationIdToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :home_location_id, :integer
  end
end
