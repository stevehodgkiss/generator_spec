# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "generator_spec/version"

Gem::Specification.new do |s|
  s.name        = "generator_spec"
  s.version     = GeneratorSpec::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Steve Hodgkiss"]
  s.email       = ["steve@hodgkiss.me.uk"]
  s.homepage    = "https://github.com/stevehodgkiss/generator_spec"
  s.summary     = %q{Test Rails generators with RSpec}
  s.description = %q{Test Rails generators with RSpec}

  s.rubyforge_project = "generator_spec"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_dependency "rails", ">= 3.0", "< 4.0"
  s.add_dependency "rspec-rails"
end
