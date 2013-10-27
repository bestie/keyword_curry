# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'keyword_curry/version'

Gem::Specification.new do |spec|
  spec.name          = "keyword_curry"
  spec.version       = KeywordCurry::VERSION
  spec.authors       = ["Stephen Best"]
  spec.email         = ["bestie@gmail.com"]
  spec.summary       = %q{Augments Ruby currying to handle required keyword arguments. Proc style objects can be curried until all its required keywords have been received}
  spec.description   = spec.summary + %q{Proc like objects can be curried until all their required keywords have been received}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.required_ruby_version = "2.1.0"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = []
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rspec", "~> 2.14"
end
