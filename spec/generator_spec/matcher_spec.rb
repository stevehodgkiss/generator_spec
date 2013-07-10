require 'spec_helper'
require 'tmpdir'

TMP_ROOT = Pathname.new(Dir.tmpdir)

describe TestGenerator, 'using custom matcher' do
  include GeneratorSpec::TestCase
  destination TMP_ROOT
  arguments %w(test --test)

  before do
    delete_directory(TMP_ROOT)
    prepare_destination
    run_generator
  end

  specify do
    destination_root.should have_structure {
      no_file 'test.rb'
      directory 'config' do
        directory 'initializers' do
          file 'test.rb' do
            contains '# Initializer'
          end
        end
      end
      directory 'db' do
        directory 'migrate' do
          file '123_create_tests.rb'
          migration 'create_tests' do
            contains 'class TestMigration'
          end
        end
      end
    }
  end

  it 'fails when it doesnt match' do
    expect {
      destination_root.should have_structure {
        directory 'db' do
          directory 'migrate' do
            no_file '123_create_tests.rb'
          end
        end
      }
    }.to raise_error
  end
end

module GeneratorSpec
  module Matcher
    describe File do
      describe '#matches?' do
        before do
          delete_directory(TMP_ROOT)
        end

        let(:file) { File.new('test_file') }
        let(:location) { TMP_ROOT.join('test_file') }

        context 'with no contains' do
          it 'doesnt throw if the file exists' do
            write_file(location, '')
            expect {
              file.matches?(TMP_ROOT)
            }.to_not throw_symbol
          end

          it 'throws :failure if it doesnt exist' do
            expect {
              file.matches?(TMP_ROOT)
            }.to throw_symbol(:failure)
          end
        end

        context 'with contains' do
          before do
            write_file(location, 'class CreatePosts')
          end

          it 'doesnt throw if the content includes the string' do
            file.contains 'CreatePosts'
            expect {
              file.matches?(TMP_ROOT)
            }.to_not throw_symbol
          end

          it 'throws :failure if the contents dont include the string' do
            file.contains 'PostsMigration'
            expect {
              file.matches?(TMP_ROOT)
            }.to throw_symbol(:failure)
          end
        end
      end
    end

    describe Migration do
      describe '#matches?' do
        before do
          delete_directory(TMP_ROOT)
        end

        let(:migration) { Migration.new('create_posts') }
        let(:location) { TMP_ROOT.join('123456_create_posts.rb') }

        context 'with no contains' do
          it 'doesnt throw if the migration exists' do
            write_file(location, 'class CreatePosts')
            expect {
              migration.matches?(TMP_ROOT)
            }.to_not throw_symbol
          end

          it 'throws :failure if it doesnt exist' do
            expect {
              migration.matches?(TMP_ROOT)
            }.to throw_symbol(:failure)
          end
        end

        context 'with contains' do
          before do
            write_file(location, 'class CreatePosts')
          end

          it 'doesnt throw if the migration includes the given content' do
            migration.contains('CreatePosts')
            expect {
              migration.matches?(TMP_ROOT)
            }.to_not throw_symbol
          end

          it 'throws failure if the migration doesnt include the given content' do
            migration.contains('CreateNotes')
            expect {
              migration.matches?(TMP_ROOT)
            }.to throw_symbol(:failure)
          end
        end
      end
    end

    describe Directory do
      describe '#location' do
        it 'equals the full path' do
          Directory.new('test').location('test_2').should eq('test/test_2')
        end
      end

      describe '#directory' do
        context 'without a block' do
          it 'adds a directory name to the tree' do
            dir = Directory.new 'test' do
              directory 'dir'
            end
            dir.tree['dir'].should eq(false)
          end
        end

        context 'with a block' do
          it 'add a directory object to the tree' do
            dir = Directory.new 'test' do
              directory 'dir' do
                directory 'test_2'
              end
            end
            dir.tree['dir'].should be_an_instance_of(Directory)
            dir.tree['dir'].tree['test_2'].should eq(false)
          end
        end
      end

      describe '#file' do
        it 'adds it to the tree' do
          dir = Directory.new 'test' do
            file 'test_file'
          end
          dir.tree['test_file'].should be_an_instance_of(File)
        end
      end

      describe '#file' do
        it 'adds it to the tree' do
          dir = Directory.new 'test' do
            migration 'test_file'
          end
          dir.tree['test_file'].should be_an_instance_of(Migration)
          dir.tree['test_file'].instance_variable_get('@name').should eq('test/test_file')
        end
      end

      describe '#matches?' do
        before do
          delete_directory(TMP_ROOT)
        end

        context 'with a directory name' do
          let(:dir) {
            Directory.new 'test' do
              directory 'test_2'
            end
          }

          it 'doesnt throw if the directory exists' do
            write_directory(TMP_ROOT.join('test/test_2'))
            expect {
              dir.matches?(TMP_ROOT)
            }.to_not throw_symbol
          end

          it 'throws :failure if it doesnt exist' do
            expect {
              dir.matches?(TMP_ROOT)
            }.to throw_symbol(:failure)
          end
        end

        context 'with a directory object' do
          let(:dir) {
            Directory.new 'test' do
              directory 'test_2' do
                file 'test_file'
              end
            end
          }

          before do
            delete_directory(TMP_ROOT)
            write_directory(TMP_ROOT.join('test/test_2'))
          end

          it 'doesnt throw if the file exists' do
            write_file(TMP_ROOT.join('test/test_2/test_file'), '')
            expect {
              dir.matches?(TMP_ROOT)
            }.to_not throw_symbol
          end

          it 'throws :failure if it doesnt exist' do
            expect {
              dir.matches?(TMP_ROOT)
            }.to throw_symbol(:failure)
          end
        end

        context '#no_file' do
          let(:dir) {
            Directory.new 'test' do
              no_file 'test_file'
            end
          }
          before do
            delete_directory(TMP_ROOT)
            write_directory(TMP_ROOT.join('test'))
          end

          it 'doesnt throw if the file exist' do
            expect {
              dir.matches?(TMP_ROOT)
            }.to_not throw_symbol
          end

          it 'throws if the file exists' do
            write_file(TMP_ROOT.join('test/test_file'), '')
            expect {
              dir.matches?(TMP_ROOT)
            }.to throw_symbol(:failure)
          end
        end
      end

    end

    describe Root do
      describe '#matches?' do
        before do
          delete_directory(TMP_ROOT)
        end

        let(:root) {
          Root.new 'test' do
            directory 'test_dir'
          end
        }

        it 'returns true on no failures' do
          write_directory(TMP_ROOT.join('test/test_dir'))
          root.matches?(TMP_ROOT).should be_true
        end

        it 'returns false on failures' do
          root.matches?(TMP_ROOT).should be_false
        end
      end
    end
  end
end
