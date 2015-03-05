class Conference < ActiveRecord::Base
  validates_presence_of :title
  after_validation :smart_add_url_protocol
  acts_as_votable
  belongs_to :user
  has_many :comments

  validates_date :start_date
  validates_date :end_date
  validates_date :end_date, :on_or_after => :start_date

  extend FriendlyId
  friendly_id :title, :use => :slugged

  scope :occurs_within, ->(date_range) {
    where('NOT(start_date > ? OR end_date < ?)', date_range.end, date_range.begin)
  }
  scope :order_by_date, -> { order(:start_date, :end_date) }

  geocoded_by :location
  after_validation :geocode

  extend DateRangeAccessor
  date_range_accessor :date_range, :start_date, :end_date

  # Elasticsearch
  searchkick

  protected

  def smart_add_url_protocol
    if url.present? && !(url =~ /\Ahttp(s)?:\/\//)
      self.url = "http://#{url}"
    end
  end
end
