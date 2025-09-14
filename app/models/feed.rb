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

  def rss
    FeedBuilder.new(self).rss
  end

  def index_html
    render_to_string("feeds/feed_index", locals: { feed: self })
  end

  def ssh_url
    "#{server.ssh_url}:#{path_with_trailing_slash}"
  end

  def path_with_trailing_slash
    path = self[:path].strip
    path.end_with?('/') ? path : "#{path}/"
  end
end
