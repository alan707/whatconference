class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token
  
  def sign_in_with(provider_name)
    @user = User.from_omniauth(request.env["omniauth.auth"], current_user)
    sign_in_and_redirect @user, :event => :authentication
    if is_navigational_format?
      set_flash_message(:notice, :success, :kind => view_context.omniauth_name(provider_name))
    end

    SLACK.ping "#{@user.username} signed in"
  end

  User.omniauth_providers.each do |provider_name|
    class_eval %Q{
      def #{provider_name}
        sign_in_with "#{provider_name}"
      end
    }
  end
end
