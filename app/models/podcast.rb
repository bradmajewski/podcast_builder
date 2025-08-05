class Podcast < ApplicationRecord
  # Not required because podcast may be created by a background process
  belongs_to :owner, class_name: "User", optional: true
  has_many :episodes
  has_one_attached :cover_art

  def published? = published_at.present?
  def publish! = update_column(:published_at, Time.current)

end
