class Conference < ActiveRecord::Base
  validates :url, presence: true
  after_validation :smart_add_url_protocol
  acts_as_votable
  belongs_to :user
  has_many :comments

  extend FriendlyId
  friendly_id :title, :use => :slugged

  protected

  def smart_add_url_protocol
    if url.present? && !url =~ /\Ahttp(s)?:\/\//
      self.url = "http://#{url}"
    end
  end
end
