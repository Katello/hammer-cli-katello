require 'rake/testtask'
require 'bundler/gem_tasks'
# require 'ci/reporter/rake/minitest'

Rake::TestTask.new do |t|
  t.libs << "lib"
  t.test_files = Dir.glob('test/**/*_test.rb')
  t.verbose = true
end

task :default do
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
