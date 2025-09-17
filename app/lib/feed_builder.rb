require 'builder'

class FeedBuilder
  attr_reader :feed

  def initialize(feed)
    @feed = feed
    @url = feed.url.chomp('/')
  end

  delegate :podcast, to: :feed

  def url(filename=nil)
    "#{@url}/#{filename}"
  end

  def index_html
    render_to_string("feed_builder/index", feed: feed)
  end

  def rss
    file = String.new # We want the string to be unfrozen
    # reference: https://help.apple.com/itc/podcasts_connect/#/itcb54353390
    xml = Builder::XmlMarkup.new(target: file, indent: 2)
    xml.instruct! :xml, :version => "1.0"
    xml.rss :version => "2.0" do
      xml.channel do
        xml.title podcast.title
        xml.description podcast.description
        # TODO: add iTunes tags
        # xml.tag! "itunes:author", podcast.author
        # xml.tag! "itunes:owner" do
        #   xml.tag! "itunes:email", podcast.owner&.email
        # end
        # xml.tag! "itunes:type", "episodic|serial"
        # xml.tag! "itunes:complete", "Yes"
        xml.language 'en-us'
        xml.pubDate podcast.published_at.rfc822 if podcast.published_at
        xml.lastBuildDate DateTime.now.rfc822
        xml.link url

        if podcast.cover_art.attached?
          xml.tag! 'itunes:image', href: url('cover-art.jpg')
        end

        feed.episodes.each do  |episode|
          xml.item do
            # xml.author episode.author
            xml.title episode.title
            xml.description episode
            xml.pubDate episode.published_at.rfc822 if episode.published_at
            xml.tag! 'itunes:duration', episode.duration.to_clock if episode.duration
            xml.guid url(episode.guid)
            xml.enclosure url: url(episode.filename), length: episode.audio_file.byte_size, type: 'audio/mpeg'
          end
        end
      end
    end
    file
  end

  private

  def render_to_string(template, **locals)
    ApplicationController.render(template: template, layout: nil, locals: locals)
  end
end
