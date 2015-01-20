# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'Cws3chk/version'

Gem::Specification.new do |spec|
  spec.name          = "Cws3chk"
  spec.version       = Cws3chk::VERSION
  spec.authors       = ["Antoine Qu'hen"]
  spec.email         = ["antoinequhen@gmail.com"]
  spec.summary       = %q{Check assets are on S3 as Carrierwave says}
  spec.description   = %q{This gem studies the existency of AR model assets, including their versions, on S3 via Resque jobs.}
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
  spec.add_runtime_dependency 'redis', '>= 3.1.0'
  spec.add_runtime_dependency 'json', '>= 1.8.2'

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "mocha", ">= 1.1.0"
end
