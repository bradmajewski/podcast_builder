class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :podcasts, foreign_key: :owner_id, inverse_of: :owner
  has_many :episodes, foreign_key: :owner_id, inverse_of: :owner

  normalizes :email, with: ->(e) { e.strip.downcase }

  validates :email,    presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, confirmation: true

  def verified? = verified_at.present?
  def verify! = update_column(:verified_at, Time.current)

  def authenticate_password = verified? && super
end
