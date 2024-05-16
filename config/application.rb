# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

require 'dotenv/load' if Rails.env.development? || Rails.env.test? || Rails.env.production?

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Myapp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1
    config.i18n.default_locale = :ja
    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.time_zone = 'Tokyo'
    # config.eager_load_paths << Rails.root.join("extras")
    config.generators do |g|
      g.skip_routes true      # Skip routes.rb file update
      g.helper false          # Don't create helper files
      g.test_framework :rspec, # Set RSpec as test framework
                       controller_specs: true,  # Enable controller specs
                       fixtures: false,         # Disable fixtures
                       helper_specs: false,     # Disable helper specs
                       model_specs: true,       # Enable model specs
                       request_specs: false,    # Disable request specs
                       routing_specs: false, # Disable routing specs
                       view_specs: false # Disable view specs
    end
  end
end
