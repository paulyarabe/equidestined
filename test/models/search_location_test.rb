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

require 'test_helper'

class SearchLocationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
