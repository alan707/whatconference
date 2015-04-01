require 'active_support/concern'

module PopularConferences
  extend ActiveSupport::Concern

  included do
    exposes :popular_conferences
  end

  def load_popular_conferences
    @popular_conferences = Conference.order_by_popularity.limit(6)
  end
end
