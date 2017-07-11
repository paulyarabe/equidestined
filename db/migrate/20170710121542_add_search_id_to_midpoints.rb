class AddSearchIdToMidpoints < ActiveRecord::Migration[5.1]
  def change
    add_column :midpoints, :search_id, :integer
  end
end
