source 'https://rubygems.org'
# Gem-ified Javascript packages created with Bower
# Helps to manage dependencies of front-end components with bundler
source 'https://rails-assets.org'
ruby '2.0.0'

# Manage environment variables for development in the .env file
gem 'dotenv-rails', :groups => [:development, :test]

gem 'rails', '4.2.0'

## Servers and system ###

# Webserver
gem 'puma'

# Database
gem 'pg'

group :production, :staging do
  gem 'rails_12factor'

  # Server monitoring
  gem 'newrelic_rpm'
end

# Easy management of environment variables
gem 'nenv'

# Slurp nil's in chains
gem 'andand'

# Easy Pure Ruby Objects
gem 'attr_extras'

# Error monitoring
gem 'rollbar', '~> 1.2'

# Notify about activity in a Slack channel
gem 'slack-notifier'

### Assets ###

gem 'sass-rails', '~> 5.0'
gem 'less-rails'
# Needed by less
gem 'therubyracer'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jquery-turbolinks'
gem 'bootstrap-sass', '~> 3.3.3'
gem 'font-awesome-rails', '~> 4.0'
gem 'bootstrap-datepicker-rails', '~> 1.3.1.1'

### Model ###

# User account management
gem 'devise', '~> 3.4.1'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
gem 'omniauth-linkedin-oauth2'
gem 'omniauth-twitter'

# Authorization
gem 'pundit'

# Date before another date
gem 'jc-validates_timeliness'

# Parse dates in mm/dd/yyyy format automatically
gem 'american_date'

# Elasticsearch
gem 'searchkick'

# Lat/lng from address, and much more
gem 'geocoder'

# Keep all versions
gem 'paper_trail', '~> 3.0'

# Tags
gem 'acts-as-taggable-on', '~> 3.4'

### Templates and views ###

# JSON templates
gem 'jbuilder', '~> 2.0'

# Generate HTML forms with less ERB
gem 'simple_form'

# Paths in words instead of ids
gem 'friendly_id', '~> 5.0'

# Format smart date ranges like Jan 30 - 31, 2015
gem 'time_will_tell'

# Client-side Coffeescript templates
gem 'eco'

# Pagination
gem 'kaminari'

# Admin dashboard
gem 'rails_admin'
gem "rails_admin_become_user"

### Javascript ###

# Packages managed by Bower
gem 'rails-assets-underscore'
gem 'rails-assets-backbone'
gem 'rails-assets-moment'
gem 'rails-assets-typeahead.js'
gem 'rails-assets-gmaps'
gem 'rails-assets-bootstrap-daterangepicker', '~> 1.3.17'
gem 'rails-assets-growl'
gem 'rails-assets-select2'

gem 'backbone-filtered-collection'

# Make Rails routes available in Javascript
gem 'js-routes'

group :development, :test do
  gem 'byebug'
  # Better console than irb
  gem 'pry'
  gem 'pry-rails'
  gem 'pry-byebug'

  gem 'spring'

  # Display more stack trace info,
  # include instance variable inspection
  gem "better_errors"
  gem "binding_of_caller"

  # Suppress the flood of Started GET "/assets/application.js" log messages
  gem 'quiet_assets'

  # Livereload
  gem 'guard-livereload', require: false
  gem 'rack-livereload'
  gem 'rb-fsevent', require: false

  # Use Chrome to debug Coffeescript
  gem 'coffee-rails-source-maps'

  # For Chrome extension Rails Panel
  gem 'meta_request'
  
end

