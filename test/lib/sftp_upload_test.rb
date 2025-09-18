require "test_helper"

class SFTPUploadTest < ActiveSupport::TestCase
  def setup
    @feed = feeds(:music)
    @uploader = SFTP::Upload.new(@feed)
    @sftp = @uploader.client
  end

  def teardown
    @uploader&.close
  end

  test "uploads" do
    @sftp.rm_f(@uploader.path(""))
    @uploader.upload
    checksums = @feed.episodes.map { |e| [e.id, e.audio_file.checksum] }.to_h
    metadata = {"version" => 1, "episodes" => checksums}.to_json

    assert_equal metadata, @uploader.read_file("metadata.json")
    assert_equal @feed.rss, @uploader.read_file("feed.rss")
    assert_equal @feed.index_html, @uploader.read_file("index.html")
    # These must match to ensure the file was written correctly. Do not remove
    # unless you replace it with equivalent functionality.
    #
    # File size is the most performant way to do this.
    assert_equal episode_byte_size(3), file_byte_size("3.mp3")
    assert_equal episode_byte_size(4), file_byte_size("4.m4a")
  end

  # NOTE: The empty file check is duplicated on both sides because both methods
  # may be called independently, so both must check for invalid data.

  def episode_byte_size(id)
    size = Episode.find(id).audio_file.byte_size
    # If file is empty, we can't tell the difference between an empty file and
    # a failed write.
    size != 0 ? size : raise("Local file is empty")
  end

  def file_byte_size(file)
    size = @sftp.stat_file(@uploader.path(file)).size
    # If file is empty, we can't tell the difference between an empty file and
    # a failed write.
    size != 0 ? size : raise("Remote file is empty")
  end
end
