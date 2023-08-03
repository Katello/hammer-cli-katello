require_relative '../test_helper'
require_relative 'sync_plan_helpers'
require_relative '../organization/organization_helpers'

describe 'delete a sync plan' do
  include OrganizationHelpers
  include SyncPlanHelpers

  let(:org_id) { 1 }
  let(:id) { 1 }
  let(:name) { "sync_plan1" }
  let(:org_name) { "org1" }

  it 'by organization ID and sync plan id' do
    api_expects(:sync_plans, :destroy, 'delete a sync plan').
      with_params('organization_id' => org_id,
                  'id' => id)
    command = %W[sync-plan delete --organization-id #{org_id} --id #{id}]
    assert_equal(0, run_cmd(command).exit_code)
  end

  it 'by organization ID and sync plan name' do
    expect_sync_plan_search(1, 'sync_plan1', 1)
    api_expects(:sync_plans, :destroy, 'delete a sync plan').
      with_params('id' => id)
    command = %W[sync-plan delete --organization-id #{org_id} --name #{name}]
    assert_equal(0, run_cmd(command).exit_code)
  end

  it 'by organization name and sync plan name' do
    expect_organization_search('org1', 1)
    expect_sync_plan_search(1, 'sync_plan1', 1)
    api_expects(:sync_plans, :destroy, 'delete a sync plan').
      with_params('id' => id)
    command = %W[sync-plan delete --organization #{org_name} --name #{name}]
    assert_equal(0, run_cmd(command).exit_code)
  end

  it 'by organization name and sync plan id' do
    expect_organization_search(org_name, org_id)
    api_expects(:sync_plans, :destroy, 'delete a sync plan').
      with_params('id' => id)
    command = %W[sync-plan delete --organization #{org_name} --id #{id}]
    assert_equal(0, run_cmd(command).exit_code)
  end
end
