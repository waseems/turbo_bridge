# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "turbo_bridge/version"

Gem::Specification.new do |s|
  s.name        = "turbo_bridge"
  s.version     = TurboBridge::VERSION
  s.authors     = ["Chris Williams"]
  s.email       = ["chris@wellnessfx.com"]
  s.homepage    = ""
  s.summary     = %q{Ruby library for using the TurboBridge API}
  s.description = %q{Ruby library for using the TurboBridge conference calling API described at http://www.turbobridge.com/api/2.0/}

  s.rubyforge_project = "turbo_bridge"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency 'rspec', '~> 2.11'

  s.add_runtime_dependency 'faraday', '~> 0.8'
  s.add_runtime_dependency 'hashie', '~> 1'
end
