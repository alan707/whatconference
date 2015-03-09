class OmniauthAccount < ActiveRecord::Base
  belongs_to :user, :autosave => true
  validates_presence_of :uid, :provider
  validates_uniqueness_of :uid, :scope => :provider

  def self.from_omniauth(auth)
    find_or_create_by(provider: auth.provider, uid: auth.uid)
  end
end
