module SearchHelpers
  def expect_generic_search(resource, args)
    ex = api_expects(resource, :index, "Find the #{resource}").with_params(args[:params])
    ex.returns(index_response([args[:returns]]))
  end

  def expect_lenient_search(resource, params:, returns:)
    ex = api_expects(resource, :index, "Find the #{resource}") do |p|
      params.each do |key, expected|
        actual = p[key] || p[key.to_sym] || p[key.to_s]
        assert_equal expected.to_s, actual.to_s, "key: '#{key}', resource: #{resource}"
      end
    end
    returns = [returns] unless returns.is_a? Array
    ex.returns(index_response(returns))
  end
end
