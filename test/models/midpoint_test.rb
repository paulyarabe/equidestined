# == Schema Information
#
# Table name: midpoints
#
#  id         :integer          not null, primary key
#  latitude   :float
#  longitude  :float
#  address    :string
#  name       :string
#  category   :string
#  rating     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class MidpointTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
