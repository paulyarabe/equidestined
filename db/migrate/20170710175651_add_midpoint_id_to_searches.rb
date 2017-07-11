class AddMidpointIdToSearches < ActiveRecord::Migration[5.1]
  def change
    add_column :searches, :midpoint_id, :integer
  end
end
