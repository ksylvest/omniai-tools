# frozen_string_literal: true

require_relative "lib/omniai/tools/version"

Gem::Specification.new do |spec|
  spec.name = "omniai-tools"
  spec.version = OmniAI::Tools::VERSION
  spec.authors = ["Kevin Sylvestre"]
  spec.email = ["kevin@ksylvest.com"]

  spec.summary = "A set of tools built for usage with OmniAI."
  spec.description = "These examples can be used for inspiration or directly within an app."
  spec.homepage = "https://github.com/ksylvest/omniai-tools"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/releases"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir.glob("{bin,lib,exe}/**/*") + %w[README.md Gemfile]

  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "omniai"
  spec.add_dependency "zeitwerk"
end
