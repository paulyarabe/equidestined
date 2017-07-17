class CreateSavedVenues < ActiveRecord::Migration[5.1]
  def change
    create_table :saved_venues do |t|
      t.integer :user_id
      t.integer :venue_id
    end
  end
end
