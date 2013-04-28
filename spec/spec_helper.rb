require 'rubygems'
require 'bundler/setup'
require 'pry'
require 'active_support/deprecation'
require 'active_support/core_ext'
require 'soan' # and any other gems you need

Dir['./spec/support/**/*.rb'].map {|f| require f }

RSpec.configure do |config|

end