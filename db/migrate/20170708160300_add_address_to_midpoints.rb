class AddAddressToMidpoints < ActiveRecord::Migration[5.1]
  def change
    add_column :midpoints, :address, :string
  end
end
