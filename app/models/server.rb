class Server < ApplicationRecord
  acts_as_paranoid
  # A server with active feeds probably shouldn't be deleted.
  has_many :feeds, dependent: :restrict_with_exception
  has_many :podcasts, through: :feeds
  belongs_to :owner, class_name: "User", optional: true

  validates :host, presence: true
  validates :port, presence: true, numericality: {
    only_integer: true,
    greater_than: 0,
    less_than: 65536 }
  # regex recommended by useradd(8)
  validates :user, presence: true, format: {
    with: /\A[a-z_][a-z0-9_-]*[$]?\z/i,
    message: "must be a valid Linux username" }
  validates :private_key, presence: true
  after_create :test_connection
  after_update :test_connection, if: :login_changed?

  normalizes :host, with: ->(h) { h.strip.downcase }
  normalizes :user, with: ->(u) { u.strip.downcase }

  boolean_date_methods :last_login_at, bang_method: :login!

  def self.find_by_host_and_user(host, user)
    find_by(host: host, user: user)
  end

  def login!
    update_column :last_login_at, Time.current
  end

  def name_for_ui
    name.presence || "#{ssh_url}"
  end

  def ssh_url
    "#{user}@#{host_with_port}"
  end

  def host_with_port
    port != 22 ? "#{host}:#{port}" : host
  end

  def sftp_session(&)
    SFTP::Client.new(self).start_session(&)
  end

  def login_changed?
    private_key_changed? || host_changed? || port_changed? || user_changed?
  end

  def test_connection # => [true, nil] or [false, error_message]
    sftp_session {}
    login!
    [true, nil]
  rescue SFTP::Error => e
    [false, "Connection failed: #{e.cause&.class&.name} #{e.message}"]
  end
end
