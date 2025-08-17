require "taglib"
# This class might be expanded in the future.
class AudioTags
  attr_reader :file

  def initialize(file)
    @file = file
  end

  def attributes
    @attributes ||= read_attributes
  end

  def read_attributes
    ::TagLib::FileRef.open(file.path) do |fr| # TagLib::FileRef
      tag = fr.tag
      properties = fr.audio_properties
      { # Using strings because a hash from a JSON field has string keys
        "album"     => tag.album.presence,
        "artist"    => tag.artist.presence,
        "comment"   => tag.comment.presence,
        "genre"     => tag.genre.presence,
        "title"     => tag.title.presence,
        "track"     => tag.track.presence,
        "year"      => tag.year.presence,
        "bitrate"   => properties.bitrate,
        "channels"  => properties.channels,
        "length_in_milliseconds" => properties.length_in_milliseconds,
        "length_in_seconds"      => properties.length_in_seconds,
        "sample_rate"            => properties.sample_rate
      }.compact
    end
  end
end
