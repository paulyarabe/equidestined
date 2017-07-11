# == Schema Information
#
# Table name: search_locations
#
#  id          :integer          not null, primary key
#  search_id   :integer
#  location_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class SearchLocation < ApplicationRecord
  belongs_to :search
  belongs_to :location
end
