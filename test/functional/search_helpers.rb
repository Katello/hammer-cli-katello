module SearchHelpers
  def expect_generic_search(resource, args)
    ex = api_expects(resource, :index, "Find the #{resource}").with_params(args[:params])
    ex.returns(index_response([args[:returns]]))
  end
end
