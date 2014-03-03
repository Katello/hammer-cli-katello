# -*- encoding: utf-8 -*-
$:.unshift(File.expand_path('../lib', __FILE__))

require 'hammer_cli_katello/version'

Gem::Specification.new do |spec|
  spec.authors = ['Katello']
  spec.email = ['katello@lists.fedorahosted.org']
  spec.license = "GPL-3"
  spec.description = 'Hammer-CLI-Katello is a plugin for Hammer to provide connectivity to a Katello server.'
  spec.summary = 'Katello commands for Hammer'
  spec.homepage = 'http://github.com/theforeman/hammer-cli-katello'

  spec.files = Dir['lib/**/*.rb']
  spec.test_files = `git ls-files -- {test,spec,features}/*`.split($\)

  spec.name = 'hammer_cli_katello'
  spec.require_paths = ['lib']
  spec.version = HammerCLIKatello.version

  spec.add_dependency 'hammer_cli_foreman', '~> 0.0.16'
  spec.add_dependency 'hammer_cli_foreman_tasks'
  spec.add_dependency 'katello_api', '~> 0.0.8'

  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'thor'
  spec.add_development_dependency 'minitest', '4.7.4'
  spec.add_development_dependency 'minitest-spec-context'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'mocha'
  spec.add_development_dependency 'ci_reporter'

  spec.add_development_dependency "rubocop", "0.17.0"
  spec.add_development_dependency "rubocop-checkstyle_formatter"
end
