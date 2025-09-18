require 'json'

module SFTP
  class Upload
    attr_reader :feed

    def initialize(feed)
      @feed = feed
    end

    def upload
      setup_folder
      checksums = metadata["episodes"] || {}
      feed.episodes.each do |episode|
        file = episode.audio_file
        checksum_mismatch = checksums[episode.id] != file.checksum
        if checksum_mismatch
          checksums[episode.id] = file.checksum

          upload_episode(episode)
        end
      end
      metadata["episodes"] = checksums
      save_metadata
      write_file("feed.rss", feed.rss)
      write_file("index.html", feed.index_html)
    end

    def close
      @client&.close
      @client = nil
    end

    def client
      @client ||= SFTP::Client.new(@feed.server).start
    end

    def metadata
      @metadata ||= (read_metadata || default_metadata)
    end

    def write_file(filename, content)
      client.write_file(path(filename), content)
    end

    def save_metadata
      write_file("metadata.json", JSON.generate(@metadata))
    end

    def path(file)
      File.join(feed.path, file)
    end

    def episode_local_path(episode)
      ActiveStorage::Blob.service.path_for(episode.audio_file.key)
    end

    def episode_remote_path(episode)
      File.join(feed.path, "#{episode.id}.#{episode.audio_file.filename.extension}")
    end

    def setup_folder
      client.find_or_create_path(path(""))
    end

    def read_file(filename)
      client.read_file(path(filename))
    end

    def upload_episode(episode)
      client.session.upload!(episode_local_path(episode), episode_remote_path(episode))
    end

    private

    def file_missing?(file)
      client.file_type(path(file)) == 'not_found'
    end

    def read_metadata
      if (json = read_file(path("metadata.json")))
        JSON.parse(json).presence
      end
    end

    def default_metadata
      {
        "version" => 1,
        "episodes" => {}
      }
    end
  end
end
