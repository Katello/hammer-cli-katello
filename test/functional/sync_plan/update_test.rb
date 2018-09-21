require_relative '../test_helper'
require_relative 'sync_plan_helpers'
require_relative '../organization/organization_helpers'

describe 'update a sync plan' do
  include OrganizationHelpers
  include SyncPlanHelpers

  let(:org_id) { 1 }
  let(:id) { 1 }
  let(:name) { "sync_plan1" }
  let(:org_name) { "org1" }
  let(:desc) { "New Description" }

  it 'with organization id and sync plan ID' do
    api_expects(:sync_plans, :update, 'update a sync plan').
      with_params('description' => desc,
                  'id' => id)
    command = %W(sync-plan update --organization-id #{org_id} --id #{id}
                 --description #{desc})
    assert_equal(0, run_cmd(command).exit_code)
  end

  it 'with organization ID and sync plan name' do
    expect_sync_plan_search(org_id, name, id)
    api_expects(:sync_plans, :update, 'update a sync plan').
      with_params('description' => desc,
                  'id' => id)
    command = %W(sync-plan update --organization-id #{org_id} --name #{name}
                 --description #{desc})
    assert_equal(0, run_cmd(command).exit_code)
  end

  it 'with organization name and sync plan name' do
    expect_organization_search(org_name, org_id)
    expect_sync_plan_search(org_id, name, id)
    api_expects(:sync_plans, :update, 'update a sync plan').
      with_params('description' => desc,
                  'id' => id)
    command = %W(sync-plan update --organization #{org_name} --name #{name}
                 --description #{desc})
    assert_equal(0, run_cmd(command).exit_code)
  end
end
