require_relative '../test_helper'
require_relative '../organization/organization_helpers'
require_relative '../content_view/content_view_helpers'
require 'hammer_cli_katello/content_view'
require 'hammer_cli_katello/content_view_purge'

module HammerCLIKatello
  describe ContentViewPurgeCommand do
    include ForemanTaskHelpers

    let(:versions) do
      {'results' => [
        {"id" => 23,
         "version" => "1.0",
         "content_view" => {"id" => 7, "name" => "test cv"},
         "composite_content_views" => [{"id" => 14, "name" => "comp_view"}],
         "composite_content_view_versions" => [],
         "environments" => [{"id" => 1, "name" => "Library"}]},
        {"id" => 34,
         "version" => "2.0",
         "content_view" => {"id" => 7, "name" => "test cv"},
         "composite_content_views" => [],
         "composite_content_view_versions" => [],
         "environments" => []},
        {"id" => 45,
         "version" => "2.10",
         "content_view" => {"id" => 7, "name" => "test cv"},
         "composite_content_views" => [],
         "composite_content_view_versions" => [],
         "environments" => [{"id" => 1, "name" => "Library"}]},
        {"id" => 56,
         "version" => "3.0",
         "content_view" => {"id" => 7, "name" => "test cv"},
         "composite_content_views" => [{"id" => 14, "name" => "comp_view"}],
         "composite_content_view_versions" => [],
         "environments" => []},
        {"id" => 67,
         "version" => "7.0",
         "content_view" => {"id" => 7, "name" => "test cv"},
         "composite_content_views" => [],
         "composite_content_view_versions" => [],
         "environments" => []},
        {"id" => 78,
         "version" => "2.0",
         "content_view" => {"id" => 7, "name" => "test cv"},
         "composite_content_views" => [],
         "composite_content_view_versions" => [{"id" => 87, "version" => "1.0"}],
         "environments" => []}
      ]}
    end

    it 'fails gracefully if count <= 0' do
      api_expects_no_call

      r = run_cmd(%w(content-view purge --id 2 --count -1))
      assert(r.err.include?('Invalid value for --count option'), 'Incorrect error message')
    end

    it 'fails gracefully when there are no versions to delete' do
      ex = api_expects(:content_view_versions, :index)
      ex = ex.with_params("content_view_id" => '2')
      ex.returns(versions)

      r = run_cmd(%w(content-view purge --id 2 --count 3))
      assert(r.err.include?('No versions to delete.'), 'Incorrect error message')
    end

    it 'only deletes unassociated versions' do
      ex = api_expects(:content_view_versions, :index)
      ex = ex.with_params("content_view_id" => '2')
      ex.returns(versions)

      [34, 67].each do |version_id|
        ex = api_expects(:content_view_versions, :destroy)
        ex = ex.with_params("id" => version_id)
        ex.returns('id' => '3', 'state' => 'stopped')
        expect_foreman_task('3')
      end

      run_cmd(%w(content-view purge --id 2 --count 0))
    end

    it 'allows for async purge of versions' do
      ex = api_expects(:content_view_versions, :index)
      ex = ex.with_params("content_view_id" => '2')
      ex.returns(versions)

      [34, 67].each do |version_id|
        ex = api_expects(:content_view_versions, :destroy)
        ex = ex.with_params("id" => version_id)
        ex.returns('id' => '3')
      end

      run_cmd(%w(content-view purge --id 2 --count 0 --async))
    end
  end
end
