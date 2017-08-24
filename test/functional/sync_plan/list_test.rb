require_relative '../test_helper'
require 'hammer_cli_katello/sync_plan'
require_relative 'sync_plan_helpers'
require_relative '../organization/organization_helpers'

module HammerCLIKatello
  describe SyncPlan::ListCommand do
    include SyncPlanHelpers
    include OrganizationHelpers

    it 'allows minimal options' do
      expect_sync_plan_search(1, nil, nil)

      run_cmd(%w(sync-plan list --organization-id 1))
    end

    it 'allows org name' do
      expect_organization_search('org1', 1)
      expect_sync_plan_search(1, nil, nil)

      run_cmd(%w(sync-plan list --organization org1))
    end

    it 'allows org label' do
      expect_organization_search('org1', 1, field: 'label')
      expect_sync_plan_search(1, nil, nil)

      run_cmd(%w(sync-plan list --organization-label org1))
    end
  end
end
