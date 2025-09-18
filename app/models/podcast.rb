class Podcast < ApplicationRecord
  acts_as_paranoid dependent_recovery_window: 5.minutes
  # Not required because podcast may be created by a background process
  belongs_to :owner, class_name: "User", optional: true
  has_many :episodes, dependent: :destroy
  # A podcast with active feeds probably shouldn't be deleted.
  has_many :feeds, dependent: :restrict_with_exception
  has_one_attached :cover_art

  validates :cover_art, processable_file: true, allow_nil: true

  scope :with_feeds_and_episodes_count, -> {
    left_outer_joins(:feeds, :episodes)
      .select(
        'podcasts.*',
        'COUNT(feeds.id) AS feeds_count',
        'COUNT(episodes.id) AS episodes_count'
      )
      .group('podcasts.id')
  }

  def published? = published_at.present?
end
