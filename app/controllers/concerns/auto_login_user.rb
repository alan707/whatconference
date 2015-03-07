require 'active_support/concern'

# Auto login a new user when doing an authenticated action and nag the
# user to actually register instead of presenting a Sign up form
module Concerns::AutoLoginUser
  extend ActiveSupport::Concern

  def authenticate_user!
    if !user_signed_in?
      user = User.create_anonymous
      sign_in user
    end
  end
end

