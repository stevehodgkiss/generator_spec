module Helpers
  module FileSystem
    def write_file(file_name, contents)
      ::File.open(file_name.to_s, 'w') {|f| f.write(contents) }
    end
    
    def write_directory(name)
      FileUtils.mkdir_p(name)
    end
  end
end