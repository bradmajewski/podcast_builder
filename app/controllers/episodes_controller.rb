class EpisodesController < ApplicationController
  layout 'card', only: %i[new create edit update]
  before_action :find_podcast
  before_action :find_episode, only: %i[ edit update destroy ]

  def new
    @episode = @podcast.episodes.build(owner: Current.user)
  end

  def create
    @episode = @podcast.episodes.build(episode_params)
    if @episode.save
      redirect_to podcast_path(@podcast), notice: "Episode created successfully."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @episode.update(episode_params)
      redirect_to podcast_path(@podcast), notice: "Episode updated successfully."
    else
      render :edit
    end
  end

  def destroy
    @episode.destroy
    redirect_to podcast_path(@podcast), notice: "Episode deleted successfully."
  end

  private

  def find_podcast
    @podcast = Podcast.find(params[:podcast_id])
  end

  def find_episode
    @episode = @podcast.episodes.find(params[:id])
  end

  def episode_params
    params.require(:episode).permit(:owner_id, :title, :description, :audio_file)
  end
end
