# == Schema Information
#
# Table name: locations
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  latitude   :float
#  longitude  :float
#  address    :string
#  name       :string
#  category   :string
#

# NOTE we can distinguish random locations entered by users by
# checking the category on the nearbys we get back (category=user?)

class Location < ApplicationRecord
  has_many :search_locations
  has_many :searches, through: :search_locations

  geocoded_by :address
  validates :address, uniqueness: true
  validates :name, uniqueness: true
  after_validation :geocode, if: :address_changed?

  def get_coordinates_from_api
    # This method can be called to return the coordinates of a location without saving it to the DB -- not sure as yet if it's needed
    Geocoder.search(self.address)[0].data["geometry"]["location"]
  end

end
