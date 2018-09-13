if RUBY_VERSION > "2.2"
  # Coverage - Keep these two lines at the top of this file
  require 'simplecov'
  require 'coveralls'
  SimpleCov.formatters = [SimpleCov::Formatter::HTMLFormatter, Coveralls::SimpleCov::Formatter]
  SimpleCov.start do
    minimum_coverage 70
    maximum_coverage_drop 0.1
    track_files "lib/**/*.rb"
    add_filter '/test/'
  end
end

require File.join(File.dirname(__FILE__), './task_helper.rb')
require 'minitest/autorun'
require 'minitest/spec'
require 'mocha/setup'
require 'hammer_cli'

KATELLO_VERSION = Gem::Version.new(ENV['TEST_API_VERSION'] || '3.9')

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
