class AddNameAndCategoryToMidpoints < ActiveRecord::Migration[5.1]
  def change
    add_column :midpoints, :name, :string
    add_column :midpoints, :category, :string, default: "midpoint"
  end
end
