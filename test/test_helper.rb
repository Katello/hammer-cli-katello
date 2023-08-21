require File.join(File.dirname(__FILE__), './task_helper.rb')
require 'minitest/autorun'
require 'minitest/spec'
require 'mocha/minitest'
require 'hammer_cli'

KATELLO_VERSION = Gem::Version.new(ENV['TEST_API_VERSION'] || '4.10')

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
