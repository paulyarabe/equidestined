class SavedVenue < ApplicationRecord
  belongs_to :user
  belongs_to :venue
end
