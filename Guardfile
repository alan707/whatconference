# A sample Guardfile
# More info at https://github.com/guard/guard#readme
require 'active_support/inflector'

group :frontend do
  # Reload the page in the browser when the HTML, JS or CSS is changed
  guard 'livereload' do
    watch(%r{app/views/.+\.(erb|haml|slim)$})
    watch(%r{app/helpers/.+\.rb})
    watch(%r{public/.+\.(css|js|html)})
    watch(%r{config/locales/.+\.yml})
    # Asset Pipeline pattern
    watch(%r{(app|vendor)(/assets/\w+/(.+\.(scss|css|js|html))).*}) { |m| "/assets/#{m[3]}" }
  end
end

