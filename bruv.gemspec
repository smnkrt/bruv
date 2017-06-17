# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "bruv/version"

Gem::Specification.new do |spec|
  spec.name          = "bruv"
  spec.version       = Bruv::VERSION
  spec.authors       = ["smnkrt"]
  spec.email         = ["skrt12@gmail.com"]

  spec.summary       = "Automate generating attr_readers and intialize method for Ruby classes."
  spec.description   = "Simple module adding helper methods for generating attr_readers with optional procs and initialize method."
  spec.homepage      = "https://github.com/smnkrt/bruv"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
