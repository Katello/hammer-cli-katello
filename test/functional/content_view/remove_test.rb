require_relative '../test_helper'
require 'hammer_cli_katello/content_view'

module HammerCLIKatello
  describe ContentView::RemoveCommand do
    include ForemanTaskHelpers

    describe 'content view version options' do
      it 'allows removing versions by ID' do
        ex = api_expects(:content_views, :remove) do |p|
          p['id'] == 1 && p['content_view_version_ids'] == %w(6 7 8)
        end
        ex.returns(id: 9)

        expect_foreman_task('9')

        run_cmd(%w(content-view remove --id 1 --content-view-version-ids 6,7,8))
      end

      it 'allows removing versions by version number' do
        versions = %w(6.0 7.0 8.0)
        ids = [6, 7, 8]

        api_expects(:content_view_versions, :index).with_params(
          'search' => %(version = "#{versions.join('" or version = "')}"),
          'content_view_id' => 1
        ).returns(index_response(ids.map { |v| { 'id' => v } }))

        api_expects(:content_views, :remove).with_params(
          'id' => 1, 'content_view_version_ids' => ids
        ).returns(id: 9)

        expect_foreman_task('9')

        run_cmd(%w(content-view remove --id 1 --content-view-versions 6.0,7.0,8.0))
      end
    end

    describe 'environment options' do
      it 'allows removing versions by ID' do
        ex = api_expects(:content_views, :remove) do |p|
          p['id'] == 1 && p['environment_ids'] == %w(6 7 8)
        end
        ex.returns(id: 9)

        expect_foreman_task('9')

        run_cmd(%w(content-view remove --id 1 --environment-ids 6,7,8))
      end

      it 'requires organization options when removing environments by name' do
        api_expects_no_call

        run_cmd(%w(content-view remove --id 1 --environments env6,env7,env8))
      end

      it 'allows removing environments by name' do
        environment_ids = [6, 7, 8]
        all_environment_ids = [3, 4, 5, 6, 7, 8]

        ex = api_expects(:lifecycle_environments, :index) do |p|
          p['organization_id'] == '1'
        end
        ex.returns(index_response(all_environment_ids.map do |id|
          {'id' => id, 'name' => "env#{id}"}
        end))

        ex = api_expects(:content_views, :remove) do |p|
          p['id'] == 1 && p['environment_ids'] == environment_ids
        end
        ex.returns(id: 9)

        expect_foreman_task('9')

        run_cmd(%w(content-view remove --id 1 --environments env6,env7,env8 --organization-id 1))
      end
    end
  end
end
