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

  def self.distance_between(loc1, loc2)
    Geocoder::Calculations.distance_between(loc1, loc2)
  end

  def find_venues(radius=0.1, category="all")
    # TODO add ability to narrow search by category
    # TODO could call yelp API in real time to get venues by address instead of using nearbys? limit search to 5 results by default
    self.nearbys(radius).select{|venue| !venue.category.nil? && venue.category != "midpoint"}
  end

  def narrow_venues_by_rating(venue_list)
    # returns 5 best rated venues
    venue_list.sort_by {|venue| venue.rating}.last(5)
  end

  def widen_search_radius(venue_list)
    # widest_radius = distance between 2 locations * 0.05
    # may want to move this code and the other distance/venue codes to search model or search controller or application controller as helper method?
  end

  def get_venue_list
    # TODO add code to call with wider radius if you get 0 venues
    # largest distance 1 mile or 5% of distance between the two points
    list = find_venues
    return list if (1..5) === list.count
    narrow_venues_by_rating(list)
  end

  def get_venue_list_new
    # TODO once this is working, widen search radius if don't get at least 2-3
    case find_venues.count
    when (1..5)
      find_venues
    when 0
      widen_search_radius(find_venues)
    else
      narrow_venues_by_rating(find_venues)
    end
  end

end
