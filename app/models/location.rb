# Location.create(address: 'full_address')
# Makes row in locations table
# <Location id: 4, latitude: 37.4042171, longitude: -77.7305227, address: "7055 Golden Aster Dr. Moseley, VA 23120">

class Location < ApplicationRecord

  geocoded_by :address        # gets address from locations
  after_validation :geocode   # gets & updates lat and long in row

  # in case you want to make a new location and look up lat,long
  def lat_long
    Geocoder.search(self.address)[0].data["geometry"]["location"]
  end

end
