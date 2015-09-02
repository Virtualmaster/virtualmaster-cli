# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "vmaster/version"

Gem::Specification.new do |s|
  s.name        = "virtualmaster"
  s.version     = VirtualMaster::VERSION
  s.authors     = ["Adam Kliment", "Radim Marek"]
  s.email       = ["adam.kliment@virtualmaster.com"]
  s.homepage    = "https://github.com/virtualmaster/virtualmaster-cli"
  s.summary     = %q{Command line interface to Virtualmaster}
  s.description = %q{Command line interface to Virtualmaster. Control your virtual infrastructure.}

  s.rubyforge_project = "vmaster"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
  
  s.add_dependency "commander", "~> 4.3"
  s.add_dependency "deltacloud-client-vm", "~> 1.1.4.3"
  s.add_dependency "terminal-table", "~> 1.5"
  s.add_dependency "net-ssh", "~> 2.9"
  s.add_dependency "xml-simple", "~> 1.1"

  s.add_development_dependency "rspec", "~> 2"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "simplecov-rcov"
end
