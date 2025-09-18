class ServersController < ApplicationController
  layout 'card', only: %i[show]
  before_action :find_server, only: %i[ show edit update destroy test ]

  def index
    @servers = Server.all
  end

  def show

  end

  def new
    @server = Server.new(owner: Current.user)
  end

  def create
    @server = Server.new(server_params)
    if @server.save
      redirect_return_to servers_path, notice: 'Server was successfully created.'
    else
      flash.now[:alert] = "Unable to create server."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @server.update(server_params)
      redirect_return_to servers_path, notice: "Server updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @server.destroy
    redirect_to servers_path, notice: 'Server destroyed.'
  rescue ActiveRecord::DeleteRestrictionError
    redirect_return_to servers_path, alert: "Cannot delete server with feeds."
  end

  def test
    success, error = @server.test_connection
    if success
      redirect_return_to servers_path, notice: "Server connection successful."
    else
      redirect_return_to servers_path, alert: "Server connection failed: #{error}"
    end
  end

  private
  def find_server
    @server = Server.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to servers_path, alert: "Server ID=#{params[:id]} not found."
  end

  def server_params
    params.require(:server).permit(:name, :owner_id, :host, :port, :user, :private_key, :host_key)
  end
end
