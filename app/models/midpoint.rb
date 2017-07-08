class Midpoint < ApplicationRecord
  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode  # auto-fetch address

  # eventually we want Location.find_by_something(params[something])
  # Location.all[0] is my home
  # Location.all[2] is Flatiron School
  def get_midpoint
    @home = Geokit::LatLng.new(Location.all[0].latitude, Location.all[0].longitude)
    @work = Geokit::LatLng.new(Location.all[2].latitude, Location.all[2].longitude)
    @latitude = @home.midpoint_to(@work).lat
    @longitude = @home.midpoint_to(@work).lng
  end

  def store_midpoint
    Midpoint.create(latitude: @latitude, longitude: @longitude)
  end

end
