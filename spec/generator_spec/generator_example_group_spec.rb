require "spec_helper"

describe TestGenerator, "using normal assert methods" do
  include GeneratorSpec::GeneratorExampleGroup

  destination File.expand_path("../../tmp", __FILE__)

  before(:all) do
    prepare_destination
    run_generator
  end

  it "creates a test initializer" do
    assert_file "config/initializers/test.rb", "# Initializer"
  end

  it "creates a migration" do
    assert_migration "db/migrate/create_tests.rb"
  end

  it "removes files" do
    assert_no_file ".gitignore"
  end
end
