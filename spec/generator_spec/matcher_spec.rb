require "spec_helper"

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