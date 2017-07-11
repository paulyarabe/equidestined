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
#

require 'test_helper'

class SearchTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
