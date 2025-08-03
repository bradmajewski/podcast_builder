class Podcast < ApplicationRecord
  belongs_to :user, optional: true
  has_many :episodes
  has_one_attached :cover_art
end
