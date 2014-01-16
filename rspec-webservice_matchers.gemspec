# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rspec/webservice_matchers/version'

Gem::Specification.new do |spec|
  spec.name          = "rspec-webservice_matchers"
  spec.version       = RSpec::WebserviceMatchers::VERSION
  spec.authors       = ["Robb Shecter"]
  spec.email         = ["robb@weblaws.org"]
  spec.description   = %q{Match specific HTTP result codes and valid HTTPS configuration}
  spec.summary       = %q{Handy matchers for testing web services}
  spec.homepage      = "https://github.com/dogweather/rspec-webservice_matchers"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
