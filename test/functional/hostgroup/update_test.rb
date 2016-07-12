require_relative '../test_helper'
require_relative '../content_view/content_view_helpers'
require_relative '../lifecycle_environment/lifecycle_environment_helpers'
require 'hammer_cli_foreman/hostgroup'

module HammerCLIForeman
  describe Hostgroup do
    # These tests are only for the extensions Katello adds to the hostgroup command
    # See hammer-cli-foreman for the core hostgroup tests
    describe UpdateCommand do
      include ContentViewHelpers
      include LifecycleEnvironmentHelpers

      it 'allows minimal options' do
        api_expects(:hostgroups, :update) do |p|
          p['id'] == '5'
        end
        run_cmd(%w(hostgroup update --id 5))
      end

      it 'allows content source id' do
        api_expects(:hostgroups, :update) do |p|
          p['id'] == '1' && p['hostgroup']['content_source_id'] == 1
        end
        run_cmd(%w(hostgroup update --id 1 --content-source-id 1))
      end

      it 'allows content view id' do
        api_expects(:hostgroups, :update) do |p|
          p['id'] == '1' && p['hostgroup']['content_view_id'] == 1
        end
        run_cmd(%w(hostgroup update --id 1 --content-view-id 1))
      end

      it 'allows content view name' do
        expect_content_view_index({'search' => 'organization_id=1', 'name' => 'cv3'}, 'id' => 3)
        api_expects(:hostgroups, :update) do |p|
          p['id'] == '1' && p['hostgroup']['content_view_id'] == 3
        end
        run_cmd(%w(hostgroup update --id 1 --content-view cv3 --organization-ids 1))
      end

      it 'allows lifecycle environment id' do
        api_expects(:hostgroups, :update) do |p|
          p['id'] == '1' && p['hostgroup']['lifecycle_environment_id'] == 1 &&
            p['hostgroup']['organization_ids'] == %w(1 2)
        end
        run_cmd(%w(hostgroup update --id 1 --lifecycle-environment-id 1 --organization-ids 1,2))
      end

      it 'allows lifecycle environment name' do
        expect_lifecycle_environment_index(
          {'search' => 'organization_id=1 or organization_id=2', 'name' => 'le1'}, 'id' => 3
        )
        api_expects(:hostgroups, :update) do |p|
          p['id'] == '1' && p['hostgroup']['lifecycle_environment_id'] == 3
        end
        run_cmd(%w(hostgroup update --id 1 --lifecycle-environment le1 --organization-ids 1,2))
      end

      it 'allows content view and lifecycle IDs' do
        api_expects(:hostgroups, :update) do |p|
          p['id'] == '1' && p['hostgroup']['lifecycle_environment_id'] == 4 &&
            p['hostgroup']['content_view_id'] == 2
        end
        run_cmd(%w(hostgroup update --id 1 --lifecycle-environment-id 4
                   --organization-ids 1,2 --content-view-id 2))
      end

      it 'allows content view name and lifecycle ID' do
        expect_content_view_index(
          {'search' => 'organization_id=1 or organization_id=2', 'name' => 'cv2'}, 'id' => 2
        )
        api_expects(:hostgroups, :update) do |p|
          p['id'] == '1' && p['hostgroup']['lifecycle_environment_id'] == 4 &&
            p['hostgroup']['content_view_id'] == 2
        end
        run_cmd(%w(hostgroup update --id 1 --lifecycle-environment-id 4
                   --organization-ids 1,2 --content-view cv2))
      end

      it 'allows content view ID and lifecycle name' do
        expect_lifecycle_environment_index(
          {'search' => 'organization_id=1 or organization_id=2', 'name' => 'le4'}, 'id' => 4
        )
        api_expects(:hostgroups, :update) do |p|
          p['id'] == '1' && p['hostgroup']['lifecycle_environment_id'] == 4 &&
            p['hostgroup']['content_view_id'] == 2
        end
        run_cmd(%w(hostgroup update --id 1 --lifecycle-environment le4
                   --organization-ids 1,2 --content-view-id 2))
      end

      it 'allows content view and lifecycle names' do
        expect_lifecycle_environment_index(
          {'search' => 'organization_id=1 or organization_id=2', 'name' => 'le4'}, 'id' => 4
        )
        expect_content_view_index(
          {'search' => 'organization_id=1 or organization_id=2', 'name' => 'cv2'}, 'id' => 2
        )
        api_expects(:hostgroups, :update) do |p|
          p['id'] == '1' && p['hostgroup']['lifecycle_environment_id'] == 4 &&
            p['hostgroup']['content_view_id'] == 2
        end
        run_cmd(%w(hostgroup update --id 1 --lifecycle-environment le4
                   --organization-ids 1,2 --content-view cv2))
      end
    end
  end
end
