# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lce/version'

Gem::Specification.new do |spec|
  spec.name          = "lce"
  spec.version       = Lce::VERSION
  spec.authors       = ["Florent Piteau", "Thomas Belliard"]
  spec.email         = ["info@lce.io"]
  spec.summary       = %q{A Ruby library that provides an interface to the LCE web services.}
  spec.homepage      = "http://lce.io/"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'webmock', '~> 1.18.0'

  spec.add_dependency "faraday", "~> 0.15.2"
  spec.add_dependency "faraday_middleware", "~> 0.12.2"
  spec.add_dependency "faraday_middleware-parse_oj", "~> 0.3.2"
  spec.add_dependency "hashie", "~> 3.6.0"  
  spec.add_dependency 'awesome_print', '~> 1.8.0'
end
