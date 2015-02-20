# Compile a separate CSS file with the framework foundation styles:
# Bootstrap and FontAwesome
# It is necessary to split the CSS into two files to work around the
# Internet Explorer limit of 4095 styles per CSS file
Rails.application.config.assets.precompile += %w(foundation.css)

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '2.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

