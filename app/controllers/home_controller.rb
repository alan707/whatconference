class HomeController < ApplicationController
  include PopularConferences

  # GET /
  def show
    if user_signed_in?
      redirect_to radar_path(current_user)
    else
      load_popular_conferences
    end
  end
end
