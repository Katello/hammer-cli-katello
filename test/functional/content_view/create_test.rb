require_relative '../test_helper'

describe 'content-view create' do
  before do
    @cmd = %w(content-view create)
    @base_params = ["--organization-id=#{org_id}", "--name=#{name}"]
  end
  let(:error_heading) { "Could not create the content view" }
  let(:name) { 'test-cv' }
  let(:org_id) { 1 }
  let(:product) do
    { 'name' => 'product-1', 'id' => 1 }
  end
  let(:repositories) do
    [
      {'name' => 'repo-1', 'id' => '1'},
      {'name' => 'repo-2', 'id' => '2'},
      {'name' => 'repo-3', 'id' => '3'}
    ]
  end

  it 'creates the content view with repositories specified by ids' do
    wanted = repositories.take(2)
    ids = wanted.map { |repo| repo['id'] }
    params = %W(--repository-ids=#{ids.join(',')})

    api_expects(:content_views, :create, 'Create content view') do |par|
      par['name'] == name &&
        par['repository_ids'] == ids &&
        par['organization_id'] == org_id
    end

    expected_result = success_result("Content view created\n")
    result = run_cmd(@cmd + @base_params + params)
    assert_cmd(expected_result, result)
  end

  it 'create the content view with repositories specified by product id and names' do
    wanted = repositories.take(2)
    ids = wanted.map { |repo| repo['id'] }
    names = wanted.map { |repo| repo['name'] }
    params = %W(--product-id=#{product['id']} --repositories=#{names.join(',')})

    api_repositories = api_expects(:repositories, :index,
                                   'Find repositories belonging to product') do |par|
      par['product_id'] == product['id']
    end
    api_repositories.returns(repositories)

    api_expects(:content_views, :create, 'Create content view') do |par|
      par['organization_id'] == org_id &&
        par['name'] == name &&
        par['repository_ids'] == ids
    end

    expected_result = success_result("Content view created\n")
    result = run_cmd(@cmd + @base_params + params)
    assert_cmd(expected_result, result)
  end

  it 'create the content view with repositories specified by product name and names' do
    wanted = repositories.take(2)
    ids = wanted.map { |repo| repo['id'] }
    names = wanted.map { |repo| repo['name'] }
    params = %W(--product=#{product['name']} --repositories=#{names.join(',')})

    api_products = api_expects(:products, :index, 'Find ID of product') do |par|
      par['organization_id'] == org_id && par['name'] == product['name']
    end
    api_products.returns(product)

    api_repositories = api_expects(:repositories, :index,
                                   'Find repositories belonging to product') do |par|
      par['product_id'] == product['id']
    end
    api_repositories.returns(repositories)

    api_expects(:content_views, :create, 'Create content view') do |par|
      par['organization_id'] == org_id &&
        par['name'] == name &&
        par['repository_ids'] == ids
    end

    expected_result = success_result("Content view created\n")
    result = run_cmd(@cmd + @base_params + params)
    assert_cmd(expected_result, result)
  end

  it 'fails on providing repository names without product' do
    params = %w(--repositories=repo-1,repo-2)

    expected_result = usage_error_result(
      @cmd,
      'At least one of options --product-id, --product is required',
      error_heading
    )

    api_expects_no_call
    result = run_cmd(@cmd + @base_params + params)
    assert_cmd(expected_result, result)
  end

  it 'fails on providing product and repository ids' do
    params = %w(--product=testproduct --repository-ids=1,2,3,4,5)

    expected_result = usage_error_result(
      @cmd,
      "You can't set any of options --product-id, --product",
      error_heading
    )

    api_expects_no_call
    result = run_cmd(@cmd + params)
    assert_cmd(expected_result, result)
  end
end
