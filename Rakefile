require 'rake/testtask'
require 'bundler/gem_tasks'

Rake::TestTask.new do |t|
  t.libs << "lib"
  t.test_files = Dir.glob('test/**/*_test.rb')
  t.verbose = true
end

begin
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new
rescue => _
  puts "Rubocop not loaded."
end

task :default do
  Rake::Task['rubocop'].execute
  Rake::Task['test'].execute
end

require "hammer_cli_katello/version"
require "hammer_cli_katello/i18n"
require "hammer_cli/i18n/find_task"
HammerCLI::I18n::FindTask.define(
  HammerCLIKatello::I18n::LocaleDomain.new,
  HammerCLIKatello.version.to_s
)
