class Episode < ApplicationRecord
  acts_as_paranoid
  # Not required because podcast may be created by a background process
  belongs_to :owner, class_name: "User", optional: true
  belongs_to :podcast
  has_one_attached :audio_file
  before_create :set_title_from_metadata, if: -> { audio_file.attached? && title.blank? }

  # Also enforced by a sqlite-specific check constraint on the table
  validate :metadata_must_be_hash

  boolean_date_methods :published_at, bang_method: :publish!

  # Need to read metadata here. A new attachment won't have a path and taglib
  # requires a file on disk. Most of the gem is written in C, including
  # initializers that accept file names.
  def audio_file=(file)
    self.metadata = AudioTags.new(file).attributes if file.present?
    self.length = metadata.fetch("length_in_seconds", 0)
    self.bitrate = metadata.fetch("bitrate", 0)
    super
  end

  # Metadata can vary widely between audio files.
  def album       = metadata["album"]
  def artist      = metadata["artist"]
  def comment     = metadata["comment"]
  def genre       = metadata["genre"]
  def title       = metadata["title"]
  def track       = metadata["track"]
  def year        = metadata["year"]
  def bitrate     = metadata["bitrate"]
  def channels    = metadata["channels"]
  def length      = metadata["length_in_seconds"]
  def sample_rate = metadata["sample_rate"]

  private
  def set_title_from_metadata
    self.title = metadata.fetch("title", "")
  end

  def metadata_must_be_hash
    errors.add(:metadata, "must be a Hash, got #{metadata.class.name}") unless metadata.is_a?(Hash)
  end
end
