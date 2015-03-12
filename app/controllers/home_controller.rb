class HomeController < ApplicationController
  exposes :popular_conferences

  # GET /
  def show
    if user_signed_in?
      redirect_to dashboard_path
    else
      load_popular_conferences
    end
  end

  private

  def load_popular_conferences
    @popular_conferences = Conference.order_by_popularity.limit(6)
  end
end
