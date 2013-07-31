require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
end

$:.unshift File.expand_path('../../', __FILE__)

require 'rspec'
require 'rr'
require 'mongoid'

require 'vidibus-recording'
require 'app/models/recording'

Dir[File.expand_path('spec/support/**/*.rb')].each { |f| require f }

# Silence logger
Vidibus::Recording.logger = Logger.new('/dev/null')

Mongoid.configure do |config|
  name = 'vidibus-recording_test'
  host = 'localhost'
  config.master = Mongo::Connection.new.db(name)
  config.logger = nil
end

RSpec.configure do |config|
  config.mock_with :rr
  config.before(:each) do
    Mongoid.master.collections.select {|c| c.name !~ /system/}.each(&:drop)
  end
end
