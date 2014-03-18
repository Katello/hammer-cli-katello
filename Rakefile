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
  Rubocop::RakeTask.new

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
end


namespace :gettext do

  desc "Update pot file"
  task :find do
    require "hammer_cli_katello/version"
    require "hammer_cli_katello/i18n"
    require 'gettext/tools'

    domain = HammerCLIKatello::I18n::LocaleDomain.new
    GetText.update_pofiles(domain.domain_name, domain.translated_files, "#{domain.domain_name} #{HammerCLIKatello.version.to_s}", :po_root => domain.locale_dir)
  end

end
