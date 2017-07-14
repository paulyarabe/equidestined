class CreateSearchVenues < ActiveRecord::Migration[5.1]
  def change
    create_table :search_venues do |t|
      t.integer :search_id
      t.integer :venue_id

      t.timestamps
    end
  end
end
