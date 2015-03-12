class RadarController < ApplicationController
  exposes :conferences, :user

  # GET /radar/username
  def show
    @user = User.friendly.find(params[:id])
    @conferences = @user.andand.conferences
  end
end
