if RUBY_VERSION > "2.2"
  # Coverage - Keep these two lines at the top of this file
  require 'simplecov'
  require 'simplecov-lcov'
  SimpleCov.formatters = [SimpleCov::Formatter::HTMLFormatter,
                          SimpleCov::Formatter::LcovFormatter]
  SimpleCov.start do
    minimum_coverage 70
    maximum_coverage_drop 0.1
    track_files "lib/**/*.rb"
    add_filter '/test/'
  end
  SimpleCov::Formatter::LcovFormatter.config do |c|
    c.report_with_single_file = true
    c.single_report_path = 'coverage/lcov.info'
  end
end

require File.join(File.dirname(__FILE__), './task_helper.rb')
require 'minitest/autorun'
require 'minitest/spec'
require 'mocha/minitest'
require 'hammer_cli'

KATELLO_VERSION = Gem::Version.new(ENV['TEST_API_VERSION'] || '4.7')

if HammerCLI.context[:api_connection]
  HammerCLI.context[:api_connection].create('foreman') do
    HammerCLI::Apipie::ApiConnection.new(
      :apidoc_cache_dir => 'test/data/' + KATELLO_VERSION.to_s,
      :apidoc_cache_name => 'foreman_api',
      :dry_run => true
    )
  end
else
  HammerCLIForeman.stubs(:resource_config).returns(
    :apidoc_cache_dir => 'test/data/' + KATELLO_VERSION.to_s,
    :apidoc_cache_name => 'foreman_api',
    :dry_run => true
  )
end

require 'hammer_cli_katello'
