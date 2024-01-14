# config/application.rb

require_relative "boot"
require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module WebSocket
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1
    config.action_cable.allowed_request_origins = ['http://127.0.0.1:3000']

    # Allow WebSocket connections from any origin
    # config.action_cable.allowed_request_origins = ['*']

    # Enable logging
    config.logger = Logger.new(STDOUT)
    config.log_level = :debug  # You can adjust the log level as needed

    # Rack::Cors configuration
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins 'http://127.0.0.1:3000'  # Replace with the actual origin of your frontend application
        resource '*',
          headers: :any,
          methods: [:get, :post, :options, :delete, :put, :patch],
          credentials: true
      end
    end

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_paths << Rails.root.join("lib")
    config.autoload_paths += Dir["#{config.root}/lib/**/"]

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
