class Following < ActiveRecord::Base
  belongs_to :user
  belongs_to :conference, :counter_cache => true

  validates_presence_of :user, :conference
end
