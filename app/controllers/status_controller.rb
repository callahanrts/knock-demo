class StatusController < ApplicationController
  before_action :authenticate_user, except: :user

  def index
    render json: { message: 'logged in' }
  end

  def user
    render json: { user: current_user }
  end
end
