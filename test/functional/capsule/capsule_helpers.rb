require_relative '../search_helpers'

module CapsuleHelpers
  include SearchHelpers

  def expect_generic_capsule_search(opts = {params: {}, returns: {}})
    expect_generic_search(:smart_proxies, opts)
  end

  def expect_capsule_info(params = {})
    api_expects(:smart_proxies, :show).with_params(params)
  end
end
