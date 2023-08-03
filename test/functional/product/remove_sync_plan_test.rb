require File.join(File.dirname(__FILE__), '../test_helper')
require File.join(File.dirname(__FILE__), '../organization/organization_helpers')
require File.join(File.dirname(__FILE__), '../sync_plan/sync_plan_helpers')
require File.join(File.dirname(__FILE__), '../product/product_helpers')

describe "remove a product's sync plan" do
  include OrganizationHelpers
  include SyncPlanHelpers
  include ProductHelpers

  it "by product ID" do
    api_expects(:products, :update, "set sync plan") do |params|
      params['id'] == 1 && params['sync_plan_id'].nil?
    end

    assert_equal(
      0,
      run_cmd(%w[product remove-sync-plan --id 1]).exit_code
    )
  end

  it "by product name" do
    expect_product_search(1, 'product1', 1)
    api_expects(:products, :update, "set sync plan") do |params|
      params['id'] == 1 && params['sync_plan_id'].nil?
    end

    assert_equal(
      0,
      run_cmd(%w[product remove-sync-plan
                 --organization-id 1
                 --name product1]).exit_code
    )
  end
end
