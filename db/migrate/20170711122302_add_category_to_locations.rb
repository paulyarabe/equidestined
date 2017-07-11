class AddCategoryToLocations < ActiveRecord::Migration[5.1]
  def change
    add_column :locations, :category, :string
  end
end
