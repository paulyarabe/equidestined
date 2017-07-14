# == Schema Information
#
# Table name: venues
#
#  id         :integer          not null, primary key
#  name       :string
#  address    :string
#  category   :string
#  rating     :integer
#  latitude   :float
#  longitude  :float
#  url        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Venue < ApplicationRecord
  has_many :search_venues
  has_many :searches, through: :search_venues

  reverse_geocoded_by :latitude, :longitude
  validates :latitude, presence: true
  validates :longitude, presence: true
  after_validation :reverse_geocode  # auto-fetch address

  API_HOST = "https://api.yelp.com"
  SEARCH_PATH = "/v3/businesses/search"
  TOKEN_PATH = "/oauth2/token"
  GRANT_TYPE = "client_credentials"
  CLIENT_ID = ENV["YELP_APP_ID"]
  CLIENT_SECRET = ENV["YELP_APP_SECRET"]

  def self.get_auth_token
    params = {client_id: CLIENT_ID, client_secret: CLIENT_SECRET, grant_type: GRANT_TYPE}
    token = HTTP.post("#{API_HOST}#{TOKEN_PATH}", params: params).parse
    "#{token['token_type']} #{token['access_token']}"
  end

  def update_db_fields(params)
    self.update(address: params[:address]) if self.latitude.nil? || self.longitude.nil?
    self.update(category: params[:category]) if self.category.nil?
    self.update(rating: params[:rating], url: params[:url])
    self
  end

  def self.add_or_update_db_row(params)
    init_params = {latitude: params[:latitude], longitude: params[:longitude], name: params[:name]}
    Venue.find_or_create_by(init_params).update_db_fields(params)
  end

  def self.save_all_to_db(api_data, term)
    api_data["businesses"].map do |business|
      params = {
        latitude: business["coordinates"]["latitude"],
        longitude: business["coordinates"]["longitude"],
        name: business["name"],
        address: business["location"]["display_address"].join(", "),
        category: term,
        url: business["url"],
        rating: business["rating"]
      }
      add_or_update_db_row(params)
    end
  end

  def self.pull_from_api(midpoint, options={})
    # Takes a midpoint object and an optional hash with the values noted below.
    # Returns an array of geocoded Venue instances, saving any to the db that aren't already in it.
    # It's possible to get back no venues depending on the search radius provided.
    #
    # :term - search term, must be a single value
    # :limit - number of results to return, max of 50
    # :radius - search radius in meters, max is 40k meters (25 mi)
    # (default radius is 805 meters, or ~0.5 mile and default limit is 5 results)
    #
    params = {
      latitude: midpoint.latitude,
      longitude: midpoint.longitude,
      term: options[:term] || "restaurants",
      limit: options[:limit] || 5,
      sort_by: "rating",
      radius: options[:radius] || 805
    }
    api_data = HTTP.auth(get_auth_token).get("#{API_HOST}#{SEARCH_PATH}", params: params).parse
    save_all_to_db(api_data, params[:term]) unless api_data.nil?
  end

  def self.find_near(midpoint, options={})
    # Takes a midpoint object and an optional hash with the values noted below.
    # Returns an array of geocoded Venue instances, saving any to the db that aren't already in it.
    # Radius starts out at 805 m (~.05 mi) and widens if we don't get back any venues, up to ~2 miles
    #
    # :term - search term, must be a single value
    # :limit - number of results to return, max of 50
    #
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
