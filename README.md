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
    
An RSpec file matching DSL is also provided, taken with permission from [beard](https://github.com/carlhuda/beard/blob/master/spec/support/matcher.rb) by [carlhuda](https://github.com/carlhuda).

    describe TestGenerator, "using custom matcher" do
      include GeneratorSpec::GeneratorExampleGroup

      destination File.expand_path("../../tmp", __FILE__)
      
      before do
        prepare_destination
        run_generator
      end

      specify do
        destination_root.should have_structure {
          no_file "test.rb"
          directory "config" do
            directory "initializers" do
              file "test.rb" do
                contains "# Initializer"
              end
            end
          end
          directory "db" do
            directory "migrate" do
              file "123_create_tests.rb"
              migration "create_tests" do
                contains "class TestMigration"
              end
            end
          end
        }
      end
    end