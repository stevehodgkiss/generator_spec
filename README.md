# Generator Spec

Allows testing of Rails generators inside RSpec using standard Rails::Generators::TestCase assertion methods.

# Usage

Add 'generator_spec' to Gemfile and use just like you would test generators in test unit:

    # spec/lib/generators/test/test_generator_spec.rb
    
    require "generator_spec/generator_example_group"
    
    describe TestGenerator do
      include GeneratorSpec::GeneratorExampleGroup

      destination File.expand_path("../../tmp", __FILE__)

      before(:all) do
        prepare_destination
        run_generator
      end

      it "creates a test initializer" do
        assert_file "config/initializers/test.rb", "# Initializer"
      end
    end