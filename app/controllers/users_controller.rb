class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  #rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }
  before_action :find_user, only: %i[ edit update ]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      start_new_session_for @user
      redirect_to root_path
    else
      flash.now[:alert] = "Unable to create user."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to edit_user_path(@user), notice: "User has been updated successfully."
    else
      flash.now[:alert] = "Unable to update user."
      render :edit, status: :unprocessable_entity
    end
  end

  private
  def find_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "User ID=#{params[:id]} not found."
  end

  def user_params
    @user_params ||= params.require(:user).permit(:email, :password, :password_confirmation, :admin, :verified)
  end
end
