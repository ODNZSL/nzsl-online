# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
# Rails.application.config.assets.precompile += %w( admin.js admin.css )

Rails.application.config.assets.precompile += %w(print.css)
Rails.application.config.assets.precompile += %w(admin.css)
Rails.application.config.assets.precompile += %w(application.css)
Rails.application.config.assets.precompile += %w(print.css)
Rails.application.config.assets.precompile += %w(print_screen.css)
Rails.application.config.assets.precompile += %w(smoothness/jquery-ui.css)
Rails.application.config.assets.precompile += %w(modernizr.js)
Rails.application.config.assets.precompile << /\.(?:svg|eot|woff|ttf|png)$/
Rails.application.config.assets.paths << "#{Rails.root}/app/assets/videos"
Rails.application.config.assets.precompile += %w(video-js.swf vjs.eot vjs.svg vjs.ttf vjs.woff)
