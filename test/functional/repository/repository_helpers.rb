module RepositoryHelpers
  def expect_repository_search(product_id, name, id)
    ex = api_expects(:repositories, :index, 'Find a repository') do |par|
      par['name'] == name && par['product_id'] == product_id
    end
    ex.returns(index_response([{'id' => id}]))
  end
end
