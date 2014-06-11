# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'formhub_ruby/version'

Gem::Specification.new do |spec|
  spec.name          = 'formhub_ruby'
  spec.version       = FormhubRuby::VERSION
  spec.authors       = ['Loïc Seigland']
  spec.email         = ['loic@loicseigland.ie']
  spec.summary       = %q(Simple Client for the Formhub API)
  # spec.description   = %q(TODO: Write a longer description. Optional.)
  spec.homepage      = 'https://github.com/concordiadiscors/FormHub-Ruby'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'addressable'

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec-nc'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-rspec'
    spec.add_development_dependency 'dotenv'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-remote'
  spec.add_development_dependency 'pry-nav'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'

end
