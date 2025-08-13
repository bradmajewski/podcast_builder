class FeedsController < ApplicationController
  layout 'card', only: %i[ new create edit update]
  before_action :find_feed, only: %i[ show edit update destroy ]
  before_action :load_servers_and_podcasts, only: %i[ new create edit update ]

  def index
    @feeds = Feed.all
  end

  def new
    @feed = Feed.new(server_id: params[:server_id], podcast_id: params[:podcast_id])
  end

  def create
    @feed = Feed.new(feed_params)
    if @feed.save
      redirect_to feeds_path, notice: 'Feed created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    if @feed.update(feed_params)
      redirect_to feeds_path, notice: "Feed updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @feed.destroy
    redirect_to feeds_path, notice: 'Feed destroyed.'
  end

  private
  def find_feed
    @feed = Feed.find(params[:id])
  end

  def load_servers_and_podcasts
    @servers = Server.all
    @podcasts = Podcast.all
  end

  def feed_params
    params.require(:feed).permit(:server_id, :podcast_id, :url, :path)
  end
end
