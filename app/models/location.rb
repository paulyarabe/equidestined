# == Schema Information
#
# Table name: locations
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  latitude   :float
#  longitude  :float
#  address    :string
#  name       :string
#  category   :string
#

# NOTE we can distinguish random locations entered by users by
# checking the category on the nearbys we get back (category=user?)

class Location < ApplicationRecord
  has_many :search_locations
  has_many :searches, through: :search_locations

  geocoded_by :address
  validates :address, presence: true
  after_validation :geocode, if: :address_changed?

end
