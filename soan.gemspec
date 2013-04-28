# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'soan/version'

Gem::Specification.new do |spec|
  spec.name          = "soan"
  spec.version       = Soan::VERSION
  spec.authors       = ["Scott Fleckenstein"]
  spec.email         = ["nullstyle@gmail.com"]
  spec.description   = %q{Cool stuff}
  spec.summary       = %q{Even more cool stuff}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"

  spec.add_dependency "celluloid"
  spec.add_dependency "celluloid-zmq"
  spec.add_dependency "activesupport"
  spec.add_dependency "ffi-msgpack"
  spec.add_dependency "uuid"


end
