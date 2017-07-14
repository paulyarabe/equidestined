# == Schema Information
#
# Table name: search_venues
#
#  id         :integer          not null, primary key
#  search_id  :integer
#  venue_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class SearchVenue < ApplicationRecord
  belongs_to :search
  belongs_to :venue
end
