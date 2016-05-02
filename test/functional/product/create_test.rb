require File.join(File.dirname(__FILE__), '../test_helper')
require File.join(File.dirname(__FILE__), '../organization/organization_helpers')
require File.join(File.dirname(__FILE__), '../sync_plan/sync_plan_helpers')
require File.join(File.dirname(__FILE__), '../product/product_helpers')

describe "create a product" do
  include OrganizationHelpers
  include SyncPlanHelpers
  include ProductHelpers

  it 'by organization ID and product name' do
    api_expects(:products, :create, 'create a product') do |par|
      par['organization_id'] == 1 && par['name'] = 'product1'
    end

    assert_equal(
      0,
      run_cmd(%w(product create --organization-id 1 --name product1)).exit_code
    )
  end

  it 'by organization name and product name' do
    expect_organization_search('org1', 1)
    api_expects(:products, :create, 'create a product') do |par|
      par['organization_id'] == 1 && par['name'] = 'product1'
    end
    assert_equal(
      0,
      run_cmd(%w(product create --organization org1 --name product1)).exit_code
    )
  end

  it 'by organization name, product name, and sync plan' do
    expect_organization_search('org1', 1)
    expect_sync_plan_search(1, 'sync_plan1', 1)
    api_expects(:products, :create, 'create a product with a sync plan') do |par|
      par['organization_id'] == 1 &&
        par['name'] == 'product1' &&
        par['sync_plan_id'] == 1
    end
    command = %w(product create --organization org1 --name product1 --sync-plan sync_plan1)
    assert_equal(
      0,
      run_cmd(command).exit_code
    )
  end

  it 'fails if no organization is given' do
    refute_equal(
      0,
      run_cmd(%w(product create --name product1)).exit_code
    )
  end
end
