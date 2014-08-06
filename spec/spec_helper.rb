require 'lce'
require 'rspec'
require 'webmock/rspec'

Lce.configure do |config|
  config.logger.level = Logger::FATAL
end


def fixture_path
  File.expand_path("../fixtures", __FILE__)
end

def fixture(file)
  File.new(fixture_path + '/' + file)
end

