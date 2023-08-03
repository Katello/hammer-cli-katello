require File.join(File.dirname(__FILE__), '../test_helper')
require File.join(File.dirname(__FILE__), '../product/product_helpers')

def expect_credentials_search(org_id, name, id)
  api_expects(:content_credentials, :index, 'List content credentials')
    .with_params('name' => name, 'organization_id' => org_id)
    .returns(index_response([{'id' => id}]))
end

describe "get content-credentials info" do
  include ProductHelpers

  before do
    @cmd = %w[content-credentials info]
  end

  let(:org_id) { 1 }
  let(:product_id) { 2 }
  let(:key_id) { 3 }

  it "Shows information about a content credental" do
    params = ["--organization-id=#{org_id}", "--name=test_key"]

    expect_credentials_search(org_id, 'test_key', key_id)

    ex = api_expects(:content_credentials, :show, "Get info") do |par|
      par["id"] == key_id
    end

    ex.returns({})

    result = run_cmd(@cmd + params)
    assert_equal(result.exit_code, 0)
  end

  it "Shows information about a key with organization-id and key name" do
    params = ["--name=test_key", "--organization-id=#{org_id}"]

    expect_credentials_search(org_id, "test_key", key_id)

    ex2 = api_expects(:content_credentials, :show, "Get info") do |par|
      par["id"] == key_id
    end

    ex2.returns({})

    result = run_cmd(@cmd + params)
    assert_equal(result.exit_code, 0)
  end
end
