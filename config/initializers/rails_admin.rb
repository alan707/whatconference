RailsAdmin.config do |config|

  ### Popular gems integration

  # == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)

  config.authorize_with do |controller|
    unless current_user.try(:admin?)
      flash[:alert] = "Unauthorized"
      redirect_to main_app.root_path
    end
  end
  

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app
    become_user do
      only 'User'
      link_icon 'fa fa-child'
    end
  end
end
