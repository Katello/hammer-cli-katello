module ProductHelpers
  def expect_generic_product_search(params = {}, returns = {})
    api_expects(:products, :index, 'Find the Product')
      .with_params(params).returns(index_response([returns]))
  end

  def expect_product_search(org_id, name, id)
    expect_generic_product_search({'name' => name, 'organization_id' => org_id}, 'id' => id)
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
