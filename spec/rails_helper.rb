# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= "test"
TEST_PORT = Random.new.rand(3001..4000)
require File.expand_path("../../config/environment", __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require "spec_helper"
require "rspec/rails"
require "shoulda/matchers"
require "with_model"
require "capybara/poltergeist" unless ENV["WEBKIT"]
require "capybara/email/rspec"
require "pundit/rspec"
require "sidekiq/testing"

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
Dir[Rails.root.join("spec/shared_examples/**/*.rb")].each { |f| require f }

# Checks for pending migration and applies them before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  # Sphinx
  config.before(:each, type: :sphinx) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each, type: :feature) do
    # :rack_test driver's Rack app under test shares database connection
    # with the specs, so continue to use transaction strategy for speed.
    driver_shares_db_connection_with_specs = Capybara.current_driver == :rack_test

    unless driver_shares_db_connection_with_specs
      # Driver is probably for an external browser with an app
      # under test that does *not* share a database connection with the
      # specs, so use truncation strategy.
      DatabaseCleaner.strategy = :truncation
    end
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.append_after(:each) do
    DatabaseCleaner.clean
  end

  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!

  config.include FactoryGirl::Syntax::Methods
  config.include Devise::TestHelpers, type: :controller
  config.include FeatureHelper, type: :feature
  config.include OmniauthMacros, type: :feature
  config.extend WithModel
  config.extend PolicyHelpers, type: :policy
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

Capybara.default_driver = ENV["WEBKIT"] ? :webkit : :poltergeist if ENV["SCREENSHOT"] || ENV["WEBKIT"]
Capybara.javascript_driver = ENV["WEBKIT"] ? :webkit : :poltergeist
Capybara.default_max_wait_time = 5

OmniAuth.config.test_mode = true
Capybara.server_port = TEST_PORT
Capybara.app_host = "http://localhost:#{TEST_PORT}"
