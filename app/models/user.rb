class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :podcasts, foreign_key: :owner_id, inverse_of: :owner
  has_many :episodes, foreign_key: :owner_id, inverse_of: :owner
  has_many :servers, foreign_key: :owner_id, inverse_of: :owner

  scope :admins, -> { where(admin: true) }

  normalizes :email, with: ->(e) { e.strip.downcase }
  validates :email,    presence: true, uniqueness: true

  before_create :promote_and_verify, if: -> { self.class.admins.count == 0 }
  before_destroy :stop_destroy, if: -> { self.class.admins.count == 1 }

  boolean_date_methods :verified_at, bang_method: :verify!

  def authenticate_password(...)
    verified? && super
  end

  def name_for_ui
    name.presence || email
  end

  private
  def promote_and_verify
    self.admin = true
    self.verified_at = Time.current
  end

  def stop_destroy
    errors.add(:base, "Cannot delete last admin user")
    throw :abort
  end
end
