module OmniauthHelper
  def omniauth_name(provider_name)
    I18n.t("omniauth_provider.#{provider_name}")
  end
  def omniauth_image_tag(provider_name, options = {})
    image_tag "omniauth_#{provider_name}.png", options.merge!(:alt => omniauth_name(provider_name), :class => "signin-icon")
  end
end
