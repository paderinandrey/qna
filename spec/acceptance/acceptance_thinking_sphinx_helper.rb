require 'rails_helper'

RSpec.configure do |config|
  config.include Capybara::DSL
  config.include Capybara::RSpecMatchers
  
  config.mock_with :rspec
  config.use_transactional_fixtures = false

  config.before(:suite) do
    # DatabaseCleaner.strategy = :deletion
      DatabaseCleaner.strategy = :truncation

    # Ensure sphinx directories exist for the test environment
    ThinkingSphinx::Test.init
    # Configure and start Sphinx, and automatically
    # stop Sphinx at the end of the test suite.
    ThinkingSphinx::Test.start_with_autostop
  end

  config.before(:each) do
    DatabaseCleaner.start
    # Index data when running an acceptance spec.
    ThinkingSphinx::Test.index
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.include SphinxHelpers, type: :request
end
