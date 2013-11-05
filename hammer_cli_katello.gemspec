$:.unshift(File.expand_path("../lib", __FILE__))

require 'hammer_cli_katello/version'

Gem::Specification.new do |spec|
  spec.name = "hammer_cli_katello"
  spec.version = HammerCLIKatello.version
  spec.authors = ["Adam Price"]
  spec.email = ["komidore64@gmail.com"]

  spec.platform = Gem::Platform::RUBY
  spec.summary = "Katello commands for Hammer"
  spec.description = "Hammer-CLI-Katello is a plugin for Hammer to provide connectivity to a Katello server."

  spec.files = Dir["lib/**/*.rb"]
  spec.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")

  spec.add_dependency("hammer_cli")
  spec.add_dependency("katello_api")
  spec.add_development_dependency("rake")
  spec.add_development_dependency("thor")
  spec.add_development_dependency("minitest", "4.7.4")
  spec.add_development_dependency("minitest-spec-context")
  spec.add_development_dependency("mocha")
  spec.add_development_dependency("ci_reporter")
  spec.add_development_dependency("simplecov")
  spec.add_development_dependency("debugger")
end
