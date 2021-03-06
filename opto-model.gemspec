# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'opto/model/version'

Gem::Specification.new do |spec|
  spec.name          = "opto-model"
  spec.version       = Opto::Model::VERSION
  spec.authors       = ["Kimmo Lehto"]
  spec.email         = ["info@kontena.io"]

  spec.licenses      = ['Apache-2.0']

  spec.summary       = %q{Uses Opto to add attributes to Ruby objects}
  spec.homepage      = "https://github.com/kontena/opto-model"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_runtime_dependency "opto", "~> 1.7"
end
