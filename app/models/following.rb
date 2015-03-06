class Following < ActiveRecord::Base
  belongs_to :user
  belongs_to :conference

  validates_presence_of :user, :conference
end
