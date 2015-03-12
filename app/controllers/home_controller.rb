class HomeController < ApplicationController
  exposes :popular_conferences

  # GET /
  def show
    if user_signed_in?
      redirect_to radar_path(current_user)
    else
      load_popular_conferences
    end
  end

  private

  def load_popular_conferences
    @popular_conferences = Conference.order_by_popularity.limit(6)
  end
end
