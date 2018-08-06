# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'royal_mail_api/version'

Gem::Specification.new do |spec|
  spec.name          = "royal_mail_api"
  spec.version       = RoyalMailApi::VERSION
  spec.authors       = ["Srikanth Kunkulagunta"]
  spec.email         = ["srikanth.kunkulagunta@gmail.com"]

  spec.summary       = %q{ruby wrapper for Royal Mail's API}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "savon", "~> 2.10"
  spec.add_dependency "activesupport", ">= 4"
  spec.add_dependency "httpclient", "~> 2.3"
  spec.add_development_dependency "vcr", "~> 4.0"
  spec.add_development_dependency "dotenv", "~> 2.0"
  spec.add_development_dependency "webmock", "~> 3.4"
  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 12.3"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry-byebug"
end
