class TestGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)
  
  def copy_initializer
    template "initializer.rb", "config/initializers/test.rb"
  end
  
  def create_migration
    template "migration.rb", "db/migrate/123_create_tests.rb"
  end
end
