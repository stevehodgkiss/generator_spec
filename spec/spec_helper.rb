require 'bundler/setup'
require 'rails/all'
require 'rspec/rails'
require 'generator_spec/generator_example_group'

Dir[Pathname.new(File.expand_path("../", __FILE__)).join("support/*/*.rb")].each {|f| require f}

RSpec.configure do |config|
  
end