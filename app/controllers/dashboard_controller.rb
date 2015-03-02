class DashboardController < ApplicationController
  exposes :conferences

  def show
    @conferences = current_user.andand.conferences
  end
end
