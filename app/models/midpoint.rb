# == Schema Information
#
# Table name: midpoints
#
#  id         :integer          not null, primary key
#  latitude   :float
#  longitude  :float
#  address    :string
#  name       :string
#  category   :string
#  rating     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# TODO - info on calling Google API directly
# https://www.sitepoint.com/use-google-maps-rails/

class Midpoint < ApplicationRecord

  reverse_geocoded_by :latitude, :longitude
  validates :latitude, presence: true
  validates :longitude, presence: true
  after_validation :reverse_geocode  # auto-fetch address

  # NOTE Midpoint objects are stored to the midpoint table as a way of reducing the number of API calls (if this midpoint has been used before, we don't need an API call), with a category of "midpoint". This will distinguish them from venues when we look at nearbys.

  def self.calculate(locations)
    # takes in an array of Location objects and returns a Midpoint object with the latitude and longitude of the geographic center/midpoint
    coords = Geocoder::Calculations.geographic_center(locations)
    self.find_or_create_by(latitude: coords[0], longitude: coords[1])
  end

  def find_venues(radius=0.1, category="all")
    # TODO add ability to narrow search by category
    self.nearbys(radius).select{|venue| !venue.category.nil? && venue.category != "midpoint"}
  end

  def narrow_venues_by_rating(venue_list)
    # returns 5 best rated venues
    venue_list.sort_by {|venue| venue.rating}.last(5)
  end

  def get_venue_list
    # TODO add code to call with wider radius if you get 0 venues
    list = find_venues
    return list if (1..5) === list.count
    narrow_venues_by_rating(list)
  end

end
