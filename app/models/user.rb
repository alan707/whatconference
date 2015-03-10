class User < ActiveRecord::Base
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
      account.user = current_user || find_or_build_user_for_omniauth(auth)
      account.user.update_from_omniauth(auth)
      account.save!
    elsif current_user && former_user != current_user
      # Associate a provider with an existing account
      # This will leave a zombie User (a user without an
      # omniauth_account) that should be merged or deleted
      account.user = current_user
      account.user.update_from_omniauth(auth)
      account.save!

      MigrateUser.new(current_user, former_user).call
    end
    
    account.user
  end

  def self.find_or_build_user_for_omniauth(auth)
    email = email_from_omniauth(auth)
    user = User.where(:email => email).first if email

    user || User.new
  end

  def update_from_omniauth(auth)
    if name.blank? || name_default?
      self.name = self.class.name_from_omniauth(auth)
    end
    if username.blank? || username_default?
      self.username = self.class.nickname_from_omniauth(auth)
    end
    if email.blank?
      self.email = self.class.email_from_omniauth(auth)
    end
  end

  def self.email_from_omniauth(auth)
    auth.info.email
  end

  def self.name_from_omniauth(auth)
    auth.info.name
  end

  def self.nickname_from_omniauth(auth)
    auth.info.first_name || auth.info.nickname || auth.uid.sub(/@.*/, "")
  end

  def remaining_providers
    self.class.omniauth_providers.map(&:to_s) - omniauth_accounts.map(&:provider)
  end

  # A new user to the site
  def self.create_anonymous
    user = User.new(
      name: name_default,
      username: username_default
    )
    user.save!
    user
  end

  def self.name_default
    'A New User'
  end

  def self.username_default
    'a new user'
  end

  def name_default?
    name == self.class.name_default
  end

  def username_default?
    username == self.class.username_default
  end

  # If the current user doesn't have any OmniauthAccounts, they won't be able to login
  def cannot_login?
    omniauth_accounts.empty?
  end

  # A user that was deleted
  def self.deleted
    new :id => 0,
      :name => "(deleted)",
      :username => "(deleted)"

  end

  # Admin dashboard config
  rails_admin do
    list do
      # Which fields to show in the list view in which order
      field :id
      field :username
      field :name
      field :email
      field :conferences
      field :omniauth_accounts
      field :sign_in_count
      field :followings
      include_all_fields
    end
  end
end
