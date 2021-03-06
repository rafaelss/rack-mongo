# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rack/mongo/version"

Gem::Specification.new do |s|
  s.name        = "rack-mongo"
  s.version     = Rack::Mongo::VERSION
  s.authors     = ["Rafael Souza"]
  s.email       = ["me@rafaelss.com"]
  s.homepage    = "http://github.com/rafaelss/rack-mongo"
  s.summary     = %q{Save data into your mongo collections through a rack app}
  s.description = %q{Save data into your mongo collections through a rack app}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "rack", ">= 1.0.0"
  s.add_runtime_dependency "yajl-ruby", "~> 0.8.2"
  s.add_runtime_dependency "mongo", "~> 1.3.1"
  s.add_runtime_dependency "bson_ext", "~> 1.3.1"
  s.add_runtime_dependency "addressable", "~> 2.2.6"
  s.add_development_dependency "rack-test", "~> 0.6.1"
  s.add_development_dependency "rspec", "~> 2.6.0"
end

