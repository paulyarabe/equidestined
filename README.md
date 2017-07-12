# EQUIDESTINED

* Notes and Development Team To-Do's:

- Location model stores user locations, i.e. addresses entered as points for which a midpoint should be found).

- Venue model stores "destinations," i.e. places where users could actually meet. It's important to keep venues and locations separate as long as we're using Geocoder (and possibly even if we get away from it, if we want to use location-aware db queries like "nearbys" functionality in Geocoder). This is because "nearbys" pulls its locations from the objects in the database and we don't want to pull a random user's place of residence as a meeting place just because we've stored it in the past when a user entered it as their location.

- There may be a better way to achieve this separation?

- Keeping Midpoint as a separate model for now, mostly because it's easier to separate geocoding and reverse geocoding. Midpoint objects are stored to the midpoint table as a way of reducing the number of API calls (if this midpoint has been used before, we don't need an API call) but are not otherwise used by the app after being stored.

- Changed Midpoint model to use Geocoder instead of Geokit to determine the midpoint. This allows us to get the midpoint for more than two locations, and appears to have more or less the same result for two. In my midpoint table, id 1 is from using Geocoder and id 3 is from using Geokit. The coordinates are slightly different but the address is the same.


# TODO - make simple view to accept two addresses and return the midpoint (think about how to get coords without API)
# NOTE - location.nearbys - geocoder method, will return any locations in the db that are nearby (defaults to 20 mi, can pass # mi as arg)
# NOTE - location.distance - gets distance in miles from your location -- see screenshot/railscast for details
#
#
# NOTE: Geocoding by full address and not doing so until after validation are conmon with rails apps, per geocoder railscast
#       The latitude and longitude will update each time the location is saved to the db, IF the address has changed.
#

***********************************************************************

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
