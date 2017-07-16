class CreateVenues < ActiveRecord::Migration[5.1]
  def change
    create_table :venues do |t|
      t.string :name
      t.string :address
      t.string :category
      t.float :rating
      t.float :latitude
      t.float :longitude
      t.string :url

      t.timestamps
    end
  end
end
