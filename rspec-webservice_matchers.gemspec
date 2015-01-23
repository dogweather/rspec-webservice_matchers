# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rspec/webservice_matchers/version'

Gem::Specification.new do |spec|
  spec.name        = 'rspec-webservice_matchers'
  spec.version     = RSpec::WebserviceMatchers::VERSION
  spec.authors     = ['Robb Shecter']
  spec.email       = ['robb@weblaws.org']
  spec.description = 'Black-box web app configuration testing'
  spec.summary     = 'Black-box web app configuration testing'
  spec.homepage    = 'https://github.com/dogweather/rspec-webservice_matchers'
  spec.license     = 'MIT'

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)\//)
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'webmock', '>= 1.20.4'

  spec.add_runtime_dependency 'rspec', '~> 3.0'
  spec.add_runtime_dependency 'excon'
  spec.add_runtime_dependency 'faraday'
  spec.add_runtime_dependency 'faraday_middleware'
end
