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
  end
end
