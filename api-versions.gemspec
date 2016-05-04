# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "api-versions/version"

Gem::Specification.new do |s|
  s.name        = "api-versions"
  s.version     = ApiVersions::VERSION
  s.authors     = ["Erich Menge", "David Celis"]
  s.email       = ["erich.menge@me.com", "me@davidcel.is"]
  s.homepage    = "https://github.com/EDMC/api-versions"
  s.summary     = "api-versions helps manage your Rails app API endpoints."
  s.description = "api-versions helps manage your Rails app API endpoints."

  s.rubyforge_project = "api-versions"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.required_ruby_version = '>= 1.9'

  s.add_dependency('actionpack', '>= 3.2')
  s.add_dependency('activesupport', '>= 3.2')

  s.add_development_dependency "rspec-rails", ">= 2.0"
  s.add_development_dependency 'ammeter',  '>= 0.2.5'
  s.add_development_dependency "coveralls"
  s.add_development_dependency 'test-unit'
end
