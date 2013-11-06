require 'rspec/core'
require 'generator_spec/generator_example_group'

RSpec::configure do |c|
  def c.escaped_path(*parts)
    Regexp.compile(parts.join('[\\\/]') + '[\\\/]')
  end

  c.include GeneratorSpec::GeneratorExampleGroup, :type => :generator, :example_group => {
    :file_path => c.escaped_path(%w[spec lib generators])
  }
end
