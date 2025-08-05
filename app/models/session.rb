class Session < ApplicationRecord
  belongs_to :user
  validates :user_is_verified

  private

  def user_is_authorized
    errors.add(:user, "must be verified") unless user&.verified?
  end
end
