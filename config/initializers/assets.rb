# Additional assets
# Rails.application.config.assets.precompile += %w(foundation.css)

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '2.0'

# Include the fonts folder
Rails.application.config.assets.paths << Rails.root.join("app", "assets", "fonts")
Rails.application.config.assets.paths << Rails.root.join("vendor", "assets", "fonts")

# Include custom fonts
Rails.application.config.assets.precompile += %w(*.svg *.eot *.woff *.ttf *.gif *.png *.ico)


