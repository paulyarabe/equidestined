# == Schema Information
#
# Table name: venues
#
#  id            :integer          not null, primary key
#  name          :string
#  address       :string
#  category      :string
#  rating        :float
#  latitude      :float
#  longitude     :float
#  url           :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  subcategories :string
#

class Venue < ApplicationRecord
  has_many :search_venues
  has_many :searches, through: :search_venues

  reverse_geocoded_by :latitude, :longitude
  validates :latitude, presence: true
  validates :longitude, presence: true
  after_validation :reverse_geocode  # auto-fetch address

  def self.build_api_query_params(search, options={})
    # Takes a search object and an optional hash with the values noted below.
    # Returns a params hash that can be passed to YelpAPI::Queries.get_businesses_from_api to pull JSON file with businesses, sorted by rating.
    #
    # :term - search term, must be a single value
    # :limit - number of results to return, max of 50 (default is 5)
    # :radius - search radius in meters, max is 40k meters (25 mi)
    # (default radius is 805 meters, or ~0.5 mile and default limit is 5 results)
    #
    params = {
      latitude: search.midpoint.latitude,
      longitude: search.midpoint.longitude,
      term: options[:term] || "restaurants",
      limit: options[:limit] || 5,
      sort_by: "rating",
      radius: options[:radius] || 805
    }
  end

  def self.build_instance_params(business, search_term)
    address = business["location"]["display_address"].join(", ")
    latitude = business["coordinates"]["latitude"] || Geocoder.coordinates(address)[0]
    longitude = business["coordinates"]["longitude"] || Geocoder.coordinates(address)[1]

    params = {
      latitude: latitude,
      longitude: longitude,
      name: business["name"],
      address: address,
      category: search_term,
      url: business["url"],
      rating: business["rating"],
      subcategories: business["categories"].map {|category| category["title"]}.join(", ")
    }
  end

  def self.save_all_to_db(api_data, search_term)
    api_data["businesses"].map do |business|
      params = self.build_instance_params(business, search_term)
      venue = Venue.find_or_create_by(name: params[:name], latitude: params[:latitude], longitude: params[:longitude])
      venue.update(params) ? venue : nil
    end
  end

  def self.pull_from_api(search, options={})
    # Takes a search object and an options hash. Options hash is not required.
    #
    # Returns an array of geocoded Venue instances "near" the search object's midpoint, sorted by rating, and saves any to the db that aren't already in it.
    # Updates db values for any venues already stored in the db.
    # Distance from midpoint and number of venues depend on params passed in through the options hash.
    #
    # NOTE Please see comments for .build_api_query_params for details about options hash, including the default values for search term, radius, and number of results.
    #
    params = self.build_api_query_params(search, options)
    api_data = YelpAPI::Queries.get_businesses_from_api(params)
    save_all_to_db(api_data, params[:term]).compact unless api_data.nil?
  end

  def self.get_widest_radius(search)
    # Returns widest search radius, based on the following criteria:
    # - If the distance between the first search location and the midpoint is 1 mile or less, maximum search radius is 806 meters (~1 mile)
    # - Else, maximum search radius is 5 % of the distance between the first search location and the midpoint (in meters)
    distance_to_midpoint = Geocoder::Calculations.distance_between(search.locations[0], search.midpoint)
    distance_to_midpoint <= 2 ? 3220 : distance_to_midpoint * 0.05 * 1609
  end

  def self.find_near(search, options={})
    # Takes a search object and an options hash and calls .pull_from_api as many
    # times as needed to return an array of at least 5 geocoded venue objects.
    # Search radius starts out at 402 meters (~0.25 miles) and widens as needed.
    #
    # Please see comments above on .build_api_query_params, .pull_from_api, and .get_widest_radius for more details.
    #
    options[:radius] = 402
    venues = pull_from_api(search, options)
    return venues unless venues.count < 5

    widest_radius = self.get_widest_radius(search)
    while options[:radius] < widest_radius do
      options[:radius] += 402
      venues += pull_from_api(search, options)
      return venues[0..4] unless venues.count < 5
    end
    venues[0..4]
  end

end
