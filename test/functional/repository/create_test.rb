require_relative '../test_helper'

describe "create repository" do
  let(:org_id) { 1 }
  let(:product_id) { 2 }
  let(:name) { "repo1" }
  let(:content_type) { "yum" }

  it 'with basic options' do
    api_expects(:repositories, :create)
      .with_params(
        name: name,
        product_id: product_id,
        content_type: content_type)

    command = %W(repository create --organization-id #{org_id} --product-id #{product_id}
                 --content-type #{content_type} --name #{name})

    assert_equal(0, run_cmd(command).exit_code)
  end
end
