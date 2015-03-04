class DashboardController < ApplicationController
  exposes :conferences

  def show
    @conferences = Conference.all.order_by_date
  end
end
