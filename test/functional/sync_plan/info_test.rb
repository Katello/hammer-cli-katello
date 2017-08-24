require_relative '../test_helper'
require 'hammer_cli_katello/sync_plan'
require_relative 'sync_plan_helpers'
require_relative '../organization/organization_helpers'
module HammerCLIKatello
  describe SyncPlan::InfoCommand do
    include OrganizationHelpers
    include SyncPlanHelpers

    it 'allows ID' do
      api_expects(:sync_plans, :show).with_params('id' => 1)

      run_cmd(%w(sync-plan info --id 1))
    end

    it 'allows organization id and sync plan name' do
      org_id = 1
      name = "SyncPlan1"
      id = 100
      expect_sync_plan_search(org_id, name, id)
      api_expects(:sync_plans, :show).with_params('id' => id)
      run_cmd("sync-plan info --organization-id #{org_id} --name #{name}".split)
    end

    it 'allows organization name and sync plan name' do
      org_id = 1
      org_label = "org"
      name = "SyncPlan1"
      id = 100

      expect_organization_search(org_label, org_id, field: 'label')
      expect_sync_plan_search(org_id, name, id)
      api_expects(:sync_plans, :show).with_params('id' => id)
      run_cmd("sync-plan info --organization-label #{org_label} --name #{name}".split)
    end
  end
end
