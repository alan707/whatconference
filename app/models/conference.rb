class Conference < ActiveRecord::Base
  validates :url, presence: true
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

  geocoded_by :full_address
  after_validation :geocode

  def full_address
    [street_address, location].compact.join(", ")
  end

  protected

  def smart_add_url_protocol
    if url.present? && !(url =~ /\Ahttp(s)?:\/\//)
      self.url = "http://#{url}"
    end
  end
end
