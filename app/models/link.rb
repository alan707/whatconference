class Link < ActiveRecord::Base
	validates :url, presence: true
	after_validation :smart_add_url_protocol
	acts_as_votable
	belongs_to :user
	has_many :comments
	

protected



def smart_add_url_protocol
  unless self.url[/\Ahttp:\/\//] || self.url[/\Ahttps:\/\//]
    self.url = "http://#{self.url}"
  end
end

end
