class Episode < ApplicationRecord
  acts_as_paranoid
  # Not required because podcast may be created by a background process
  belongs_to :owner, class_name: "User", optional: true
  belongs_to :podcast


  # Also enforced by a sqlite-specific check constraint on the table
  validate :metadata_must_be_hash

  boolean_date_methods :published_at, bang_method: :publish!

  private
  def metadata_must_be_hash
    errors.add(:metadata, "must be a Hash, got #{metadata.class.name}") unless metadata.is_a?(Hash)
  end
end
