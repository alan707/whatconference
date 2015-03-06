class DashboardController < ApplicationController
  exposes :conferences

  def show
    @conferences = Conference.none
  end
end
