# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jumio_rock/version'

Gem::Specification.new do |spec|
  spec.name          = "jumio_rock"
  spec.version       = JumioRock::VERSION
  spec.authors       = ["Michele Minazzato"]
  spec.email         = ["michelemina@gmail.com"]
  spec.summary       = "Unofficial Jumio API Integration"
  spec.description   = "Netverify is a customer-friendly technology that utilizes computer vision technology to collect and validate customer personal data (PII)."
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "excon", '0.32.1'
  spec.add_development_dependency "minitest", '4.7.5'
  spec.add_development_dependency "rake", '10.2.2'
  spec.add_development_dependency "chunky_png", '1.3.1'
  spec.add_development_dependency "webmock", '1.17.4'
end
