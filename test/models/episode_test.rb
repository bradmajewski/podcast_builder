require "test_helper"

class EpisodeTest < ActiveSupport::TestCase
  test "the truth" do
    assert true
  end

  test "sqlite check constraint on metadata field" do
    podcast = Podcast.create
    episode = podcast.episodes.new(metadata: '')
    error = assert_raises 'ActiveRecord::StatementInvalid' do
      episode.save
    end
    assert_match(/chk_metadata_is_object/, error.message)
  end
end
