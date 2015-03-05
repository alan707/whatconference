source 'https://rubygems.org'
# Gem-ified Javascript packages created with Bower
# Helps to manage dependencies of front-end components with bundler
source 'https://rails-assets.org'
ruby '2.0.0'

gem 'dotenv-rails', :groups => [:development, :test]

gem 'rails', '4.2.0'
gem 'bootstrap-datepicker-rails', '~> 1.3.1.1'
gem 'puma'
gem 'pg'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jquery-turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc

# User account management
gem 'devise', '~> 3.4.1'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
gem 'omniauth-linkedin-oauth2'
gem 'omniauth-twitter'

gem 'bootstrap-sass', '~> 3.3.3'
gem 'font-awesome-rails', '~> 4.0'
gem 'acts_as_votable', '~> 0.10.0'
gem 'simple_form'
gem 'friendly_id', '~> 5.0'
gem 'js-routes'
gem 'time_will_tell'
gem 'jc-validates_timeliness'
gem 'geocoder'
gem 'nenv'
gem 'andand'

# Parse dates in mm/dd/yyyy format automatically
gem 'american_date'

# Client-side Coffeescript templates
gem 'eco'

# Admin dashboard
gem 'rails_admin'
gem "rails_admin_become_user"

# Javascript packages managed by Bower
gem 'rails-assets-underscore'
gem 'rails-assets-backbone'
gem 'rails-assets-moment'
gem 'rails-assets-gmaps'
gem 'rails-assets-flat-ui'
gem 'rails-assets-bootstrap-daterangepicker', '~> 1.3.17'

gem 'backbone-filtered-collection'

group :development, :test do
  gem 'byebug'
  # Better console than irb
  gem 'pry'
  gem 'pry-rails'
  gem 'pry-byebug'

  gem 'web-console', '~> 2.0'
  gem 'spring'

  # Suppress the flood of Started GET "/assets/application.js" log messages
  gem 'quiet_assets'

  # Livereload
  gem 'guard-livereload', require: false
  gem 'rack-livereload'
  gem 'rb-fsevent', require: false

  # Use Chrome to debug Coffeescript
  gem 'coffee-rails-source-maps'
end

group :production, :staging do
  gem 'rails_12factor'
end

