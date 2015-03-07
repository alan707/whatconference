class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  include Concerns::ExposeIvar
  include Concerns::AutoLoginUser
  include Pundit


  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def new_session_path(scope)
    new_user_session_path
  end

  protected

  def default_rescue_path
    main_app.root_path
  end

  def user_not_authorized
    redirect_to (request.referrer || default_rescue_path), :alert => "You are not authorized to access this page."
  end

  def record_not_found
    redirect_to default_rescue_path, :alert => "We couldn't find what you were looking for."
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :username
    devise_parameter_sanitizer.for(:account_update) << :username
  end
end
