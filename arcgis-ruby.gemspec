# -*- encoding: utf-8 -*-
# stub: arcgis-ruby 0.0.1 ruby lib

Gem::Specification.new do |s|
  s.name = "arcgis-ruby"
  s.version = "0.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Jake Sower"]
  s.date = Time.now.strftime("%Y-%m-%d")
  s.email = "jsower@esri.com"
  s.summary = "A simple wrapper for ArcGIS Online sharing API"
  s.license = 'apache'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]


  s.add_dependency 'typhoeus', ">= 0.8.0"
  s.add_dependency 'json'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rake'

end
