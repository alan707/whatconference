class User < ActiveRecord::Base
  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  # Devise user authentication
  devise :rememberable, :trackable, :omniauthable,
         :omniauth_providers => [:twitter, :facebook, :linkedin, :google_oauth2,
                                 *(:developer if Rails.env.development?)]

  # Associations
  has_many :created_conferences, :class => Conference, :foreign_key => 'creation_user_id'
  has_many :omniauth_accounts, :dependent => :destroy
  has_many :followings, :dependent => :destroy
  has_many :conferences, :through => :followings
  has_many :comments

  # Omniauth
  def self.from_omniauth(auth, current_user)
    account = OmniauthAccount.from_omniauth(auth)

    former_user = account.user
    if former_user.nil?
      # First time signing in with a provider
      account.user = current_user || find_or_create_user_for_omniauth(auth)
      account.save!
    elsif current_user && former_user != current_user
      # Associate a provider with an existing account
      # This will leave a zombie User (a user without an
      # omniauth_account) that should be merged or deleted
      account.user = current_user
      account.save!

      MigrateUser.new(current_user, former_user).call
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

  # A new user to the site
  def self.create_anonymous
    user = User.new(
      name: 'Anonymous',
      username: 'anonymous'
    )
    user.save!
    user
  end

  # If the current user doesn't have any OmniauthAccounts, they won't be able to login
  def cannot_login?
    omniauth_accounts.empty?
  end

  # A user that was deleted
  def self.deleted
    new :name => "(deleted)",
      :username => "(deleted)"

  end
end
