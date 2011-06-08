# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "projector/version"

Gem::Specification.new do |s|
  s.name        = "projector"
  s.version     = Projector::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jay Zeschin"]
  s.email       = ["jay@zeschin.org"]
  s.homepage    = "https://github.com/jayzes/projector"
  s.summary     = %q{Automatically keep a working directory with checkouts of all your Github projects}
  s.description = %q{Automatically keep a working directory with checkouts of all your Github projects}
  
  s.add_dependency 'json'
  s.add_dependency 'thor'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
