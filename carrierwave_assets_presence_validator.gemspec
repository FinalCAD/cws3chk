# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'carrierwave_assets_presence_validator/version'

Gem::Specification.new do |spec|
  spec.name          = "carrierwave_assets_presence_validator"
  spec.version       = CarrierwaveAssetsPresenceValidator::VERSION
  spec.authors       = ["Antoine Qu'hen"]
  spec.email         = ["antoinequhen@gmail.com"]
  spec.summary       = %q{Check assets are on S3 as DB says}
  spec.description   = %q{This gem adds rake tasks and resque jobs to check that AR model assets assets are really on S3, including their versions.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'rails', '>= 4.1.8'
  spec.add_runtime_dependency 'aws', '>= 2.10.2'
  spec.add_runtime_dependency 'resque', '>= 1.25.2'
  spec.add_runtime_dependency 'retryable_block', '>= 0.0.1'
  spec.add_runtime_dependency 'threadify_procs', '>= 0.0.5'

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
