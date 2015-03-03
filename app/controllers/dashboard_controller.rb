class DashboardController < ApplicationController
  exposes :conferences

  def show
    @conferences = Conference.all
  end
end
