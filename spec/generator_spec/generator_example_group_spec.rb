require 'spec_helper'

module GeneratorSpec
  describe GeneratorExampleGroup do
    it { should be_included_in_files_in('./spec/lib/generators/') }
  end
end
