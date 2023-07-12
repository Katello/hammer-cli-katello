require 'rake/testtask'
require 'bundler/gem_tasks'
require 'ci/reporter/rake/minitest'

Rake::TestTask.new do |t|
  t.libs << "lib"
  t.test_files = Dir.glob('test/**/*_test.rb')
  t.verbose = true
end

begin
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new

  desc "Runs Rubocop style checker with xml output for Jenkins"
  task 'rubocop:jenkins' do
    system("bundle exec rubocop \
            --require rubocop/formatter/checkstyle_formatter \
            --format Rubocop::Formatter::CheckstyleFormatter \
            --no-color --out rubocop.xml")
  end
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
