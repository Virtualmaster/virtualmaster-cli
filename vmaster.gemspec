# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "vmaster/version"

Gem::Specification.new do |s|
  s.name        = "vmaster"
  s.version     = VirtualMaster::VERSION
  s.authors     = ["Radim Marek"]
  s.email       = ["radim@laststation.net"]
  s.homepage    = ""
  s.summary     = %q{Command line interface to VirtualMaster}
  s.description = %q{Command line interface to VirtualMaster. Control your virtual infrastructure.}

  s.rubyforge_project = "vmaster"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
  
  s.add_dependency "commander", "~> 4.1.2"
  s.add_dependency "deltacloud-client", "~> 0.5.0"
  s.add_dependency "terminal-table", "~> 1.4.4"
  s.add_dependency "net-ssh", "~> 2.3.0"

  s.add_development_dependency "rspec", "~> 2"
end
