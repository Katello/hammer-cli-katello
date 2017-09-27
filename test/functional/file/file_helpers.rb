require_relative '../search_helpers'

module FileHelpers
  include SearchHelpers

  def expect_file_search(params, returns)
    expect_generic_search(:file_units, params: params, returns: returns)
  end

  def expect_file_show(params)
    api_expects(:file_units, :show).with_params(params)
  end
end
