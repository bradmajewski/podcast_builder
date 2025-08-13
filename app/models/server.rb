class Server < ApplicationRecord
  acts_as_paranoid
  # A server with active feeds probably shouldn't be deleted.
  has_many :feeds, dependent: :restrict_with_exception
  belongs_to :owner, class_name: "User", optional: true

  validates :host, presence: true
  validates :port, presence: true, numericality: { only_integer: true, greater_than: 0, less_than: 65536 }
  # regex recommended by useradd(8)
  validates :user, presence: true, format: { with: /\A[a-z_][a-z0-9_-]*[$]?\z/i, message: "must be a valid Linux username" }
  validates :key, presence: true

  def name_for_ui
    name.presence || "#{ssh_url}"
  end

  def ssh_url
    "#{user}@#{host_with_port}"
  end

  def host_with_port
    port != 22 ? "#{host}:#{port}" : host
  end
end
