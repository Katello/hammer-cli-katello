module ProductHelpers
  def expect_product_search(org_id, name, id)
    ex = api_expects(:products, :index, 'Find the Product') do |par|
      par['name'] == name && par['organization_id'] == org_id
    end
    ex.returns(index_response([{'id' => id}]))
  end

  def expect_product_show(options = {})
    raise "#{__method__} must be called with :id" unless (options.keys & [:id]).size == 1

    if options[:name]
      raise "#{__method__} used with :name also requires :org_id" unless options[:org_id]
      expect_product_search(options[:org_id], options[:name], options[:id])
    end

    ex = api_expects(:products, :show, 'Show a Product') do |par|
      par['id'] == options[:id]
    end
    ex.returns(index_response([{'id' => options[:id]}]))
  end
end
