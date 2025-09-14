require "test_helper"

class EpisodeTest < ActiveSupport::TestCase
  test "verify fixtures contain audio attachments" do
    assert episodes(:music_one).audio_file.attached?
    assert episodes(:music_two).audio_file.attached?
  end

  test "sqlite check constraint on metadata field" do
    podcast = Podcast.create
    episode = podcast.episodes.new(metadata: '')
    error = assert_raises 'ActiveRecord::StatementInvalid' do
      episode.save(validate: false)
    end
    assert_match(/chk_metadata_is_object/, error.message)
  end
end
