class Conference < ActiveRecord::Base
  validates_presence_of :title
  validates_presence_of :date_range
  after_validation :smart_add_url_protocol

  # Associations
  belongs_to :creation_user, :class => User
  has_many :followings, :dependent => :destroy
  has_many :followers, :through => :followings, :source => :user
  has_many :comments

  validates_date :start_date
  validates_date :end_date
  validates_date :end_date, :on_or_after => :start_date

  extend FriendlyId
  friendly_id :title

  def should_generate_new_friendly_id?
    slug.blank? || title_changed?
  end

  scope :occurs_within, ->(date_range) {
    where('NOT(start_date > ? OR end_date < ?)', date_range.end, date_range.begin)
  }
  scope :order_by_date, -> { order(:start_date, :end_date) }
  scope :order_by_popularity, -> { order('followings_count DESC') }

  geocoded_by :location
  after_validation :geocode

  extend DateRangeAccessor
  date_range_accessor :date_range, :start_date, :end_date

  # Elasticsearch
  searchkick word_start: [:title]

  # Version history
  has_paper_trail

  # Add or remove a follower
  def follow(user)
    raise ArgumentError, "Must provide a user" if user.nil?

    follower = followers.find_by_id(user.id)
    if follower.nil?
      followers << user
      true
    else
      followers.delete user
      false
    end
  end

  def creation_user
    super || User.deleted
  end

  def named_followers
    @named_followers ||= followers.reject(&:name_default?)
  end

  protected

  def smart_add_url_protocol
    if url.present? && !(url =~ /\Ahttp(s)?:\/\//)
      self.url = "http://#{url}"
    end
  end

  # Admin dashboard config
  rails_admin do
    list do
      # Which fields to show in the list view in which order
      field :id
      field :title
      field :date_range do
        formatted_value { bindings[:view].date_range(value.begin, value.end) }
      end
      field :creation_user
      field :city_state
      field :url
      field :location
      field :followers
      field :followings
      field :created_at do
        formatted_value { value.andand.strftime("%F") }
      end
      include_all_fields
    end
  end
end
