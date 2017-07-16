# == Schema Information
#
# Table name: venues
#
#  id            :integer          not null, primary key
#  name          :string
#  address       :string
#  category      :string
#  rating        :integer
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
    params = self.build_api_query_params(search, options={})
    api_data = YelpAPI::Queries.get_businesses_from_api(params)
    save_all_to_db(api_data, params[:term]).compact unless api_data.nil?
  end

  def self.find_near(search, options={})
    # Takes a midpoint object and an optional hash with the values noted below.
    # Returns an array of geocoded Venue instances, saving any to the db that aren't already in it.
    # Radius starts out at 805 m (~.05 mi) and widens if we don't get back any venues, up to ~2 miles
    #
    # :term - search term, must be a single value
    # :limit - number of results to return, max of 50
    #
    # TODO fix radius algorithm
    # NOTE  Geocoder::Calculations.distance_between(search.locations[0], search.midpoint)
    # TODO get more than 5 venues and narrow it down some? grab 5 parks, 2 bars, 5 restaurants, and 2 coffee places and then mix it up and return 5? Maybe remove anything with a rating lower than 2 or not enough ratings? Idk
    # TODO maybe give user option to specify open now and check against is_closed?
    params = {
      latitude: midpoint.latitude,
      longitude: midpoint.longitude,
      term: options[:term] || "restaurants",
      limit: options[:limit] || 5,
      sort_by: "rating",
      radius: 805
    }

    while params[:radius] < 3220 do
      venues = pull_from_api(midpoint, params)
      return venues unless venues.count < 5
      params[:radius] += 805
    end

    venues
  end

end
