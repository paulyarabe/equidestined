# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
loc1 = Location.create(address: "50 W 34th St, New York, NY 10001", name: "sarah's apartment", category: "home")
loc2 = Location.create(address: "11 Broadway, New York, NY", name: "flatiron", category: "school")
Midpoint.calculate([loc1, loc2])

YelpAPI.add_businesses_to_db("New York, NY", "restaurants")
YelpAPI.add_businesses_to_db("New York, NY", "parks")
YelpAPI.add_businesses_to_db("New York, NY", "bars")
