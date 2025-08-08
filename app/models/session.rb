class Session < ApplicationRecord
  belongs_to :user
  validate :user_is_verified

  private

  def user_is_verified
    errors.add(:user, "must be verified") unless user&.verified?
  end
end
