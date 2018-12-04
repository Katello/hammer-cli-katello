require_relative '../search_helpers'

module RepositorySetHelpers
  include SearchHelpers

  def expect_repository_set_search(name, id, organization_id: nil, product_id: nil)
    params = {'name' => name}
    params.merge(organization_id: organization_id) if organization_id.nil?
    params.merge(product_id: product_id) if product_id.nil?
    expect_generic_repository_sets_search(
      params: params,
      returns: {'id' => id})
  end

  def expect_generic_repository_sets_search(params: {}, returns: [])
    api_expects(:repository_sets, :index, 'Find repository sets')
      .with_params(params)
      .returns(index_response(returns))
  end
end
