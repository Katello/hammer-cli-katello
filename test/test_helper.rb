require File.join(File.dirname(__FILE__), './task_helper.rb')
require 'minitest/autorun'
require 'minitest/spec'
require 'mocha/setup'
require 'hammer_cli'
require 'hammer_cli_foreman/commands'
require 'simplecov'
require 'coveralls'

if RUBY_VERSION > "2.2"
  # don't run coverage for every ruby version in Travis
  SimpleCov.formatters = [SimpleCov::Formatter::HTMLFormatter, Coveralls::SimpleCov::Formatter]
  SimpleCov.start do
    add_filter '/test/'
  end
end

KATELLO_VERSION = Gem::Version.new(ENV['TEST_API_VERSION'] || '3.0')

HammerCLIForeman.stubs(:resource_config).returns(
  :apidoc_cache_dir => 'test/data/' + KATELLO_VERSION.to_s,
  :apidoc_cache_name => 'foreman_api',
  :dry_run => true
)

require 'hammer_cli_katello'
