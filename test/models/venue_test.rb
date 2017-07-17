# == Schema Information
#
# Table name: venues
#
#  id            :integer          not null, primary key
#  name          :string
#  address       :string
#  category      :string
#  rating        :float
#  latitude      :float
#  longitude     :float
#  url           :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  subcategories :string
#

require 'test_helper'

class VenueTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
