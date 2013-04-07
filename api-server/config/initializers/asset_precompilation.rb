# From https://github.com/thomas-mcdonald/bootstrap-sass:
#   "Due to a change in Rails that prevents images from being compiled in vendor and lib, you'll need to add the
#    following line to your application.rb:"
Rails.application.config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif)
