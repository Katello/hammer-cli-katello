require 'rake/testtask'
require 'bundler/gem_tasks'
# require 'ci/reporter/rake/minitest'

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

namespace :gettext do

  task :setup do
    require "hammer_cli_katello/version"
    require "hammer_cli_katello/i18n"
    require 'gettext/tools/task'

    domain = HammerCLIKatello::I18n::LocaleDomain.new
    GetText::Tools::Task.define do |task|
      task.package_name = domain.domain_name
      task.package_version = HammerCLIKatello.version.to_s
      task.domain = domain.domain_name
      task.mo_base_directory = domain.locale_dir
      task.po_base_directory = domain.locale_dir
      task.files = domain.translated_files
    end
  end

  desc "Update pot file"
  task :find => [:setup] do
    Rake::Task["gettext:po:update"].invoke
  end

end
