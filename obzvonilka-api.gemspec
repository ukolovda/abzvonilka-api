# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'obzvonilka/api/version'

Gem::Specification.new do |spec|
  spec.name          = "obzvonilka-api"
  spec.version       = Obzvonilka::Api::VERSION
  spec.authors       = ["ukolovda"]
  spec.email         = ["udmitry@mail.ru"]

  spec.summary       = %q{Obzvonilka.ru API}
  spec.description   = %q{Obzvonilka.ru API}
  spec.homepage      = "https://github.com/ukolovda/abzvonilka-api"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 1.8.7'

  spec.add_dependency "rest-client"
  spec.add_dependency "json"
  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "rcov" if RUBY_VERSION =~ /^1.8/
end
