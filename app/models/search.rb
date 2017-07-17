# == Schema Information
#
# Table name: searches
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  name        :string
#  notes       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  midpoint_id :integer
#  venue_type  :string
#

class Search < ApplicationRecord
  belongs_to :midpoint
  has_many :search_locations
  has_many :locations, through: :search_locations
  has_many :search_venues
  has_many :venues, through: :search_venues

  validates :midpoint_id, presence: true
  validate :has_at_least_two_locations?, on: :create

  def has_at_least_two_locations?
    errors.add(:locations, "Please enter at least two addresses.") unless self.locations.select{|location| !location.address.nil? && !location.address.empty?}.count >= 2
  end

end
