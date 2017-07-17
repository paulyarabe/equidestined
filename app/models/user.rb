# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string
#  email           :string
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  is_admin        :boolean
#

class User < ApplicationRecord
  has_secure_password
  has_many :searches

  has_many :saved_venues
  has_many :venues, through: :saved_venues

  has_many :follows
  has_many :follower_relationships, foreign_key: :following_id, class_name: 'Follow'
  has_many :followers, through: :follower_relationships, source: :follower
  has_many :following_relationships, foreign_key: :user_id, class_name: 'Follow'
  has_many :following, through: :following_relationships, source: :following

  validates :email, uniqueness: true

  def follow(other_user)
    self.following << other_user
  end

  def unfollow(other_user)
    self.following.delete(other_user)
  end

  def following?(other_user)
    # returns true if current_user is following other_user
    self.following.include?(other_user)
  end

  def save_venue(venue)
    self.venues << venue
  end

end
