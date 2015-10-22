require 'rubygems'
require 'bundler/setup'
require 'simplecov'
require 'webmock/rspec'
require 'coveralls'
Coveralls.wear!

WebMock.disable_net_connect!(allow_localhost: true)

SimpleCov.start do
  add_filter "/spec/"
end

Dir[File.expand_path(File.join(File.dirname(__FILE__), "..", "lib", "**", '*.rb'))].each {|f| require f}
