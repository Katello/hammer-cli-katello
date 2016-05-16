module ProductHelpers
  def expect_product_search(org_id, name, id)
    ex = api_expects(:products, :index, 'Find the Product') do |par|
      par['name'] == name && par['organization_id'] == org_id
    end
    ex.returns(index_response([{'id' => id}]))
  end
end
