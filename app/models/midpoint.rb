# == Schema Information
#
# Table name: midpoints
#
#  id         :integer          not null, primary key
#  latitude   :float
#  longitude  :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  address    :string
#

class Midpoint < ApplicationRecord

  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode  # auto-fetch address

  # NOTE at present, this model exists mostly because it's easier to separate geocoding and reverse geocoding. Midpoint objects are stored to the midpoint table as a way of reducing the number of API calls (if this midpoint has been used before, we don't need an API call) but are not otherwise used by the app after being stored.

  def self.calculate(locations)
      # takes in an array of Location objects and returns a Midpoint object with the latitude and longitude of the geographic center/midpoint
      coords = Geocoder::Calculations.geographic_center(locations)
      self.find_by(latitude: coords[0], longitude: coords[1]) || self.create(latitude: coords[0], longitude: coords[1])
  end

end
