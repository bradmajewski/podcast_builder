class RecoveryController < ApplicationController
  # If you add a model, you need to add a redirect in the undelete method
  SAFE_MODELS = [Podcast, Episode, Server, Feed].map(&:name).freeze
  before_action :only_allows_safe_models, only: %i[recover]
  layout 'card', only: %i[episode]


  def index
    @podcasts = Podcast.only_deleted
    @episodes = Episode.only_deleted.joins(:podcast).where(podcasts: {deleted_at: nil})
    @servers = Server.only_deleted
    @feeds = Feed.only_deleted.joins(:podcast).where(podcasts: { deleted_at: nil })
  end

  def recover
    model = params[:model].classify.constantize
    record = model.with_deleted.find(params[:id])
    if record.recover
      case record
      when Podcast
        redirect_to record, notice: "Podcast restored."
      when Episode
        redirect_to podcast_path(record.podcast), notice: "Episode \"#{record.title}\" restored."
      when Server
        redirect_to servers_path, notice: "Server \"#{record.name_for_ui}\" restored."
      when Feed
        redirect_to feeds_path, notice: "Feed for podcast \"#{record.podcast.title}\" restored."
      else # Shouldn't happen but a future developer could forget to add a redirect
        raise "Unknown model type: #{model.name}"
      end
    else
      redirect_to recovery_path, alert:
        "Failed to restore #{model.name} with ID=#{record.id}. #{record.errors.full_messages.join(", ")}"
    end
  end

  def episode
    @episode = Episode.only_deleted.find(params[:id])
    @podcast = Podcast.with_deleted.find_by(id: @episode.podcast_id)
    if request.post?
      episode_params = params.require(:episode).permit(:audio_file)
      @episode.assign_attributes(episode_params)
      if @episode.recover
        redirect_to podcast_path(@episode.podcast), notice: "Episode \"#{@episode.title}\" restored."
      else
        flash.now[:alert] = "Failed to restore Episode with ID=#{@episode.id}. #{@episode.errors.full_messages.join(", ")}"
      end
    end
  end

  private

  def only_allows_safe_models
    unless SAFE_MODELS.map(&:to_s).include?(params[:model]&.classify)
      redirect_to restore_path, alert: "Cannot restore #{params[:model]}."
    end
  end
end
