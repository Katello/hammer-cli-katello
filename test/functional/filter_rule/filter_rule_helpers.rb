require_relative '../search_helpers'

module FilterRuleHelpers
  include SearchHelpers

  def expect_filter_rule_search(name, filter_id, return_id)
    expect_generic_search(
      :content_view_filter_rules,
      params: {search: "name = \"#{name}\"", 'content_view_filter_id' => filter_id},
      returns: {'id' => return_id})
  end
end
