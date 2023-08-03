require File.join(File.dirname(__FILE__), '../test_helper')
require File.join(File.dirname(__FILE__), '../organization/organization_helpers')
require File.join(File.dirname(__FILE__), '../product/product_helpers')

describe "get product info" do
  include OrganizationHelpers
  include ProductHelpers

  it 'by ID' do
    expect_product_show(:id => 1)
    assert_equal(
      0,
      run_cmd(%w[product info --id 1]).exit_code
    )
  end

  it 'by organization id and product name' do
    expect_product_show(:name => 'product1', :org_id => 1, :id => 1)
    assert_equal(
      0,
      run_cmd(%w[product info --organization-id 1 --name product1]).exit_code
    )
  end

  it 'by organization name and product name' do
    expect_organization_search('org1', 1)
    expect_product_show(:name => 'product1', :org_id => 1, :id => 1)
    assert_equal(
      0,
      run_cmd(%w[product info --organization org1 --name product1]).exit_code
    )
  end
end
