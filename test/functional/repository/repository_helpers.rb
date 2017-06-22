module RepositoryHelpers
  def expect_repository_search(product_id, name, id)
    api_expects(:repositories, :index, 'Find a repository')
      .with_params('name' => name, 'product_id' => product_id)
      .returns(index_response([{'id' => id}]))
  end

  def expect_repositories_search(org_id, names, ids)
    expect_generic_repositories_search({'names' => names, 'organization_id' => org_id},
      ids.zip(names).map { |id, name| { 'id' => id, 'name' => name } })
  end

  def expect_generic_repositories_search(params = {}, returns = [])
    api_expects(:repositories, :index, 'Find repositories')
      .with_params(params)
      .returns(index_response(returns))
  end
end
