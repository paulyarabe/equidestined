class CreateMidpoints < ActiveRecord::Migration[5.1]
  def change
    create_table :midpoints do |t|
      t.float :latitude
      t.float :longitude
      t.string :address
      t.string :name
      t.string :category
      t.integer :rating

      t.timestamps
    end
  end
end
