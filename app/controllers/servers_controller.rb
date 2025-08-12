class ServersController < ApplicationController
  before_action :find_server, only: %i[ edit update destroy ]

  def index
    @servers = Server.all
  end

  def new
    @server = Server.new(owner: Current.user)
  end

  def create
    @server = Server.new(server_params)
    if @server.save
      redirect_to servers_path, notice: 'Server was successfully created.'
    else
      flash.now[:alert] = "Unable to create server."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @server.update(server_params)
      redirect_to servers_path, notice: "Server updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @server.destroy
    redirect_to servers_path, notice: 'Server destroyed.'
  rescue ActiveRecord::DeleteRestrictionError
    redirect_to servers_path, alert: "Cannot delete server with associated feeds."
  end

  private
  def find_server
    @server = Server.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to servers_path, alert: "Server ID=#{params[:id]} not found."
  end

  def server_params
    params.require(:server).permit(:name, :owner_id, :host, :port, :user, :key)
  end
end
