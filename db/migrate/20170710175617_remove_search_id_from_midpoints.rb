class RemoveSearchIdFromMidpoints < ActiveRecord::Migration[5.1]
  def change
    remove_column :midpoints, :search_id, :integer
  end
end
