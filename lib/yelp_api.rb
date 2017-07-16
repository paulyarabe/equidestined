module YelpAPI

  class Queries < Rails::Application

    API_HOST = "https://api.yelp.com"
    BUSINESS_SEARCH_PATH = "/v3/businesses/search"
    TOKEN_PATH = "/oauth2/token"
    GRANT_TYPE = "client_credentials"
    CLIENT_ID = ENV["YELP_APP_ID"]
    CLIENT_SECRET = ENV["YELP_APP_SECRET"]

    def self.get_auth_token
      # Returns an oauth2 bearer token for the Yelp API
      params = {client_id: CLIENT_ID, client_secret: CLIENT_SECRET, grant_type: GRANT_TYPE}
      token = HTTP.post("#{API_HOST}#{TOKEN_PATH}", params: params).parse
      "#{token['token_type']} #{token['access_token']}"
    end

    def self.get_businesses_from_api(options)
      # Takes an options hash that may contain some or all of the values noted below.
      # Returns an array of venues in JSON format.
      #
      # NOTE - :latitude and :longitude MUST be in the options hash
      #
      # :term - search term, must be a single value (i.e. "restauarants" or "bars")
      # :limit - number of results to return, default of 20, max of 50
      # :offset - this allows you to get the next page of results, default is 0
      # :radius - search radius in meters, max is 40k meters (25 mi)
      # :sort_by - options are "best_match", "rating", "distance", or "review_count"
      #
      params = {
        latitude: options[:latitude],
        longitude: options[:longitude],
        term: options[:term],
        limit: options[:limit],
        offset: options[:offset] || 0,
        sort_by: options[:sort_by] || "rating",
        radius: options[:radius]
      }
      HTTP.auth(self.get_auth_token).get("#{API_HOST}#{BUSINESS_SEARCH_PATH}", params: params).parse
    end

  # NOTE - Sample while loop for getting large number of businesses at once
    # offset = 0
    # while offset < options[:limit] do
    #   get_businesses_from_api(options)
    #   offset += 50
    # end

end
