class Episode < ApplicationRecord
  acts_as_paranoid
  # Not required because podcast may be created by a background process
  belongs_to :owner, class_name: "User", optional: true
  belongs_to :podcast
  has_one_attached :audio_file

  before_create :set_published_from_filename

  scope :published, -> { where.not(published_at: nil) }

  validate :metadata_must_be_hash # Also enforced by check constraint
  validates :audio_file, attached: true, processable_file: true

  def published?  = published_at.present?
  def filename    = "#{id}.#{file_ext}"
  def file_ext    = audio_file.filename.extension
  def guid        = id   # only needs to be unique inside a feed
  # Metadata can vary widely between audio files.
  def meta_title  = metadata["title"].presence
  def album       = metadata["album"]
  def artist      = metadata["artist"]
  def comment     = metadata["comment"]
  def genre       = metadata["genre"]
  def track       = metadata["track"]
  def year        = metadata["year"]
  def bitrate     = metadata["bitrate"]
  def channels    = metadata["channels"]
  def sample_rate = metadata["sample_rate"]

  # Need to read metadata here. A new attachment won't have a path and taglib
  # requires a file on disk. Most of the gem is written in C, including
  # initializers that accept file names.
  def audio_file=(file)
    self.metadata = AudioTags.new(file).attributes if file.present?
    self.title    = metadata.fetch("title", "") if title.blank?
    self.duration = metadata.fetch("length_in_seconds", 0)
    self.bitrate  = metadata.fetch("bitrate", 0)
    super
  end

  private

  def set_published_from_filename
    self.published_at ||= Date.parse(File.basename(audio_file.filename.to_s, ".*"))
  rescue Date::Error
  end

  def audio_file_is_mpeg
    if audio_file.attached? && audio_file.content_type !~ %r`\Aaudio\/`
      errors.add(:audio_file, "must be an audio file")
    end
  end

  def metadata_must_be_hash
    unless metadata.is_a?(Hash)
      errors.add(:metadata, "must be a Hash, got #{metadata.class.name}")
    end
  end
end
