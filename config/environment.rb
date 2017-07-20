# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

DatabaseCleaner.logger = Rails.logger
