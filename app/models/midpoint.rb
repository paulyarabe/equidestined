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
#  name       :string
#  category   :string           default("midpoint")
#

class Midpoint < ApplicationRecord

  reverse_geocoded_by :latitude, :longitude
  validates :latitude, presence: true
  validates :longitude, presence: true
  after_validation :reverse_geocode  # auto-fetch address

  # NOTE Midpoint objects are stored to the midpoint table as a way of reducing the number of API calls (if this midpoint has been used before, we don't need an API call), with a category of "midpoint". This will distinguish them from venues when we look at nearbys.

  def self.calculate(locations)
      # takes in an array of Location objects and returns a Midpoint object with the latitude and longitude of the geographic center/midpoint
      coords = Geocoder::Calculations.geographic_center(locations)
      self.find_by(latitude: coords[0], longitude: coords[1]) || self.create(latitude: coords[0], longitude: coords[1])
  end

  def find_venues(radius=10, category="restaurants")
    self.nearbys(radius).select{|venue| !venue.category.nil? && venue.category != "midpoint"}
  end

end
