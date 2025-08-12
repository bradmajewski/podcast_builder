class PodcastsController < ApplicationController
  before_action :find_podcast, only: %i[ show edit update destroy ]
  def index
    @podcasts = Podcast.all
  end

  def show
  end

  def new
    @podcast = Podcast.new(owner: Current.user)
  end

  def create
    @podcast = Podcast.new(podcast_params)
    if @podcast.save
      redirect_to @podcast, notice: 'Podcast was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @podcast.update(podcast_params)
      redirect_to @podcast, notice: 'Podcast was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @podcast.destroy
    redirect_to podcasts_path, notice: 'Podcast was successfully destroyed.'
  end

  private
  def find_podcast
    @podcast = Podcast.find(params[:id])
  end

  def podcast_params
    params.require(:podcast).permit(:title, :description, :owner_id, :published, :cover_art)
  end
end
