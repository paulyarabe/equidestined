class YelpAPI  < ApplicationRecord

  API_HOST = "https://api.yelp.com"
  SEARCH_PATH = "/v3/businesses/search"
  TOKEN_PATH = "/oauth2/token"
  GRANT_TYPE = "client_credentials"
  DEFAULT_LOCATION = "New York, NY"
  SEARCH_LIMIT = 50
  CLIENT_ID = ENV["YELP_APP_ID"]
  CLIENT_SECRET = ENV["YELP_APP_SECRET"]

  # get oauth2 token from Yelp API

  def self.get_auth_token
    params = {
      client_id: CLIENT_ID,
      client_secret: CLIENT_SECRET,
      grant_type: GRANT_TYPE
    }
    token = HTTP.post("#{API_HOST}#{TOKEN_PATH}", params: params).parse

    "#{token['token_type']} #{token['access_token']}"
  end

  def self.add_or_update_business(params)
    business =  Midpoint.find_or_create_by(latitude: params[:latitude], longitude: params[:longitude], name: params[:name])
    business.update(rating: params[:rating])
    business.update(category: params[:category]) if business.category.nil?
  end

  def self.save_businesses_to_db(api_data, term)
    api_data["businesses"].each do |business|
      params = {
        latitude: business["coordinates"]["latitude"],
        longitude: business["coordinates"]["longitude"],
        name: business["name"],
        category: term,
        rating: business["rating"]
      }
      add_or_update_business(params)
    end
  end

  def self.get_businesses_from_api(location=DEFAULT_LOCATION, offset=0, term="restaurants")
    params = {
      location: location,
      term: term,
      limit: SEARCH_LIMIT,
      offset: offset
    }
    api_data = HTTP.auth(get_auth_token).get("#{API_HOST}#{SEARCH_PATH}", params: params).parse
    save_businesses_to_db(api_data, term) unless api_data.nil?
  end

  def self.add_businesses_to_db(location=DEFAULT_LOCATION, term="restaurants")
    offset = 0
    while offset < 1000 do
      get_businesses_from_api(location, offset, term)
      offset += 50
    end
  end

end
