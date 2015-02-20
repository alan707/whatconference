class User < ActiveRecord::Base
  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :rememberable, :trackable, :omniauthable,
         :omniauth_providers => [:twitter, :facebook, :linkedin, :google_oauth2,
                                 *(:developer if Rails.env.development?)]

  has_many :conferences
  has_many :omniauth_accounts, :dependent => :destroy

  def self.from_omniauth(auth, current_user)
    account = OmniauthAccount.from_omniauth(auth)

    if account.user.nil?
      # First time signing in with a provider
      account.user = current_user || find_or_create_user_for_omniauth(auth)
      account.save!
    elsif current_user && account.user != current_user
      # Associate a provider with an existing account
      # This will leave a zombie User (a user without an
      # omniauth_account) that should be merged or deleted
      account.user = current_user
      account.save!
    end
    
    account.user
  end

  def self.find_or_create_user_for_omniauth(auth)
    email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
    email = auth.info.email if email_is_verified
    user = User.where(:email => email).first if email

    if user.nil?
      user = User.new(
        name: auth.extra.andand.raw_info.andand.name || auth.info.name,
        username: auth.info.nickname || auth.uid.sub(/@.*/, ""),
        email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
      )
      user.save!
    end
    user
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end

  def remaining_providers
    self.class.omniauth_providers.map(&:to_s) - omniauth_accounts.map(&:provider)
  end
end
