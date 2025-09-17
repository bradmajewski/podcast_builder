class Feed < ApplicationRecord
  acts_as_paranoid
  belongs_to :server
  belongs_to :podcast
  has_many :episodes, -> { published.order(:published_at) }, through: :podcast

  delegate :owner, to: :server, allow_nil: true

  validates :server, presence: true
  validates :podcast, presence: true
  validates :url, presence: true
  validates :path, presence: true

  delegate :rss, :index_html, to: :builder

  def builder
    @feed_builder ||= FeedBuilder.new(self)
  end

  def ssh_url
    "#{server.ssh_url}:#{path_with_trailing_slash}"
  end

  def path_with_trailing_slash
    path = self[:path].strip
    path.end_with?('/') ? path : "#{path}/"
  end
end
