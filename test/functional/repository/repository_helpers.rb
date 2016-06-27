module RepositoryHelpers
  def expect_repository_search(product_id, name, id)
    ex = api_expects(:repositories, :index, 'Find a repository') do |par|
      par['name'] == name && par['product_id'] == product_id
    end
    ex.returns(index_response([{'id' => id}]))
  end

  def expect_repositories_search(org_id, names, ids)
    ex = api_expects(:repositories, :index, 'Find repositories') do |par|
      par['names'] == names && par['organization_id'] == org_id
    end
    ex.returns(index_response(ids.zip(names).map { |id, name| { 'id' => id, 'name' => name } }))
  end
end
