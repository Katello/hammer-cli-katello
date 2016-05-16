module RepositoryHelpers
  def expect_repository_search(org_id, product_id, name, id)
    ex = api_expects(:repositories, :index, 'Find a repository') do |par|
      par['name'] == name && par['organization_id'] == org_id &&
        par['product_id'] == product_id
    end
    ex.returns(index_response([{'id' => id}]))
  end
end
