class CreateSearchLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :search_locations do |t|
      t.integer :search_id
      t.integer :location_id

      t.timestamps
    end
  end
end
