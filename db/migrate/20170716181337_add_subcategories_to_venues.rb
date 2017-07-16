class AddSubcategoriesToVenues < ActiveRecord::Migration[5.1]
  def change
    add_column :venues, :subcategories, :string
  end
end
