require 'spec_helper'

class TestClass
  
end

describe GeneratorSpec::TestCase do
  before do
    @klass = Class.new do
      self.should_receive(:described_class).and_return(TestClass)
      include GeneratorSpec::TestCase
    end
    @klass.test_case_instance = double
  end
  
  it 'passes unknown messages on to test_case_instance' do
    @klass.test_case_instance.should_receive(:assert_file).with('test')
    @klass.new.assert_file('test')
  end
  
  it 'handles respond_to accordingly' do
    @klass.test_case_instance.should_receive(:respond_to?).with(:assert_no_file).and_return(true)
    @klass.new.respond_to?(:assert_no_file).should be_true
  end
end

describe TestGenerator, 'using normal assert methods' do
  include GeneratorSpec::TestCase
  destination File.expand_path('../../tmp', __FILE__)
  arguments %w(test --test)
  
  before(:all) do
    prepare_destination
    run_generator
  end

  it 'creates a test initializer' do
    assert_file 'config/initializers/test.rb', '# Initializer'
  end

  it 'creates a migration' do
    assert_migration 'db/migrate/create_tests.rb'
  end

  it 'removes files' do
    assert_no_file '.gitignore'
  end
end

describe TestGenerator, 'with contexts' do
  include GeneratorSpec::TestCase
  destination File.expand_path('../../tmp', __FILE__)
  before { prepare_destination }
  
  context 'with --test flag' do
    before { run_generator %w(test --test) }
    
    it 'creates a test initializer' do
      assert_file 'config/initializers/test.rb', '# Initializer'
    end
  end
  
  context 'without any flags' do
    before { run_generator %w(test) }
    
    it 'doesn\'t create a test initializer' do
      assert_no_file 'config/initializers/test.rb'
    end
  end
end
