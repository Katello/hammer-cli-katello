# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))

require 'hammer_cli_katello/version'

Gem::Specification.new do |gem|
  gem.authors = [
    "Adam Price",
    "Adam Ruzicka",
    "Andrew Kofink",
    "Brad Buckingham",
    "Bryan Kearney",
    "Chris Duryee",
    "Christine Fouant",
    "Daniel Lobato García",
    "David Davis",
    "Dustin Tsang",
    "Eric D. Helms",
    "Ivan Nečas",
    "Jason L Connor",
    "Jason Montleon",
    "John Mitsch",
    "Justin Sherrill",
    "Martin Bačovský",
    "Michaux Kelley",
    "Og Maciel",
    "Partha Aji",
    "Pavel Moravec",
    "Roman Plevka",
    "Stephen Benjamin",
    "Tomas Strachota",
    "Tom McKay",
    "Walden Raines",
    "Zach Huntington-Meath"
  ]
  gem.email = ['katello@lists.fedorahosted.org']
  gem.license = "GPL-3"
  gem.description = 'Hammer-CLI-Katello is a plugin for Hammer to provide' \
    ' connectivity to a Katello server.'
  gem.summary = 'Katello commands for Hammer'
  gem.homepage = 'http://github.com/theforeman/hammer-cli-katello'

  gem.files = Dir['config/**/*', 'lib/**/*.rb', 'locale/**/**']
  gem.test_files = `git ls-files -- {test,spec,features}/*`.split($ORS)

  gem.name = 'hammer_cli_katello'
  gem.require_paths = ['lib']
  gem.version = HammerCLIKatello.version

  gem.add_dependency 'hammer_cli_foreman', '~> 0.6'
  gem.add_dependency 'hammer_cli_foreman_tasks', '~> 0.0.3'
  gem.add_dependency 'hammer_cli_foreman_bootdisk'
  gem.add_dependency 'hammer_cli_foreman_docker'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'thor'
  gem.add_development_dependency 'minitest', '4.7.4'
  gem.add_development_dependency 'minitest-spec-context'
  gem.add_development_dependency 'mocha'
  gem.add_development_dependency 'ci_reporter'

  gem.add_development_dependency "rubocop", "0.39"
  gem.add_development_dependency "rubocop-checkstyle_formatter"
end
