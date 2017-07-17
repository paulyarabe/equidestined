class AddVenueTypeToSearches < ActiveRecord::Migration[5.1]
  def change
    add_column :searches, :venue_type, :string
  end
end
