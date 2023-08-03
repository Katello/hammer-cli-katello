require File.join(File.dirname(__FILE__), '../test_helper')
require File.join(File.dirname(__FILE__), 'product_helpers')

describe "listing products" do
  include ProductHelpers

  let(:empty_response_table) do
    <<~EOSTRING
      ---|------|-------------|--------------|--------------|-----------
      ID | NAME | DESCRIPTION | ORGANIZATION | REPOSITORIES | SYNC STATE
      ---|------|-------------|--------------|--------------|-----------
    EOSTRING
  end

  it 'displays the table properly' do
    api_expects(:products, :index, 'index products').returns(index_response([]))
    assert_cmd(
      success_result(empty_response_table),
      run_cmd(%w[product list --organization-id 1])
    )
  end

  it 'by organization ID' do
    ex = api_expects(:products, :index, 'index products') do |par|
      par['organization_id'] == 1
    end
    ex.returns(index_response([]))

    assert_equal(
      0,
      run_cmd(%w[product list --organization-id 1]).exit_code
    )
  end

  it 'by organization ID and subscription ID' do
    ex = api_expects(:products, :index, 'organization product list') do |par|
      par['organization_id'] == 1 && par['subscription_id'] == 1
    end
    ex.returns(index_response([]))

    assert_equal(
      0,
      run_cmd(%w[product list --organization-id 1 --subscription-id 1]).exit_code
    )
  end

  it 'by organization ID and sync plan ID' do
    ex = api_expects(:products, :index, 'organization product list') do |par|
      par['organization_id'] == 1 && par['sync_plan_id'] == 1
    end
    ex.returns(index_response([]))

    assert_equal(
      0,
      run_cmd(%w[product list --organization-id 1 --sync-plan-id 1]).exit_code
    )
  end
end
