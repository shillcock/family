require "rollbar/rails"
Rollbar.configure do |config|
  config.access_token = ENV["ROLLBAR_ACCESS_TOKEN"]
  config.enabled = ENV["ROLLBAR_ACCESS_TOKEN"].present?
end

