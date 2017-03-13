require_relative '../test_helper'
require_relative '../organization/organization_helpers'
require_relative '../content_view/content_view_helpers'
require 'hammer_cli_katello/content_view'
require 'hammer_cli_katello/content_view_purge'

module HammerCLIKatello
  describe ContentViewPurgeCommand do
    include ForemanTaskHelpers

    let(:versions) do
      {'versions' => [
        {"id" => '2', "version" => "1.0", "published" => "2017-03-09 19:48:25 UTC",
         "environment_ids" => []},
        {"id" => '4', "version" => "2.2", "published" => "2017-03-09 19:50:29 UTC",
         "environment_ids" => [1]},
        {"id" => '6', "version" => "2.10", "published" => "2017-03-09 19:50:29 UTC",
         "environment_ids" => []}
      ]}
    end

    it 'fails gracefully if count <= 0' do
      api_expects_no_call

      r = run_cmd(%w(content-view purge --id 2 --count -1))
      assert(r.err.include?('Invalid value for --count option'), 'Incorrect error message')
    end

    it 'fails gracefully when there are no versions to delete' do
      ex = api_expects(:content_views, :show) do |p|
        p['id'] == '2'
      end
      ex.returns(versions)

      r = run_cmd(%w(content-view purge --id 2 --count 3))
      assert(r.err.include?('No versions to delete.'), 'Incorrect error message')
    end

    it 'only deletes versions not associated with an environment' do
      ex = api_expects(:content_views, :show) do |p|
        p['id'] == '2'
      end
      ex.returns(versions)

      %w(2 6).each do |id|
        ex = api_expects(:content_view_versions, :destroy) do |p|
          p['id'] == id
        end
        ex.returns('id' => '3', 'state' => 'stopped')
        expect_foreman_task('3')
      end

      run_cmd(%w(content-view purge --id 2 --count 0))
    end

    it 'allows for async purge of versions' do
      ex = api_expects(:content_views, :show) do |p|
        p['id'] == '2'
      end
      ex.returns(versions)

      %w(2 6).each do |id|
        ex = api_expects(:content_view_versions, :destroy) do |p|
          p['id'] == id
        end
        ex.returns('id' => '3')
      end

      run_cmd(%w(content-view purge --id 2 --count 0 --async))
    end
  end
end
