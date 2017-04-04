require_relative '../search_helpers'

module ContentViewHelpers
  include SearchHelpers

  def expect_content_view_search(org_id, name, id)
    expect_generic_content_view_search(params: {'name' => name, 'organization_id' => org_id},
                                       returns: {'id' => id})
  end

  def expect_generic_content_view_search(args)
    expect_generic_search(:content_views, args)
  end
end
