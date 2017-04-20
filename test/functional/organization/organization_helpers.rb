require_relative '../search_helpers'

module OrganizationHelpers
  include SearchHelpers

  def expect_organization_search(name_or_label, id, field: 'name')
    expect_generic_search(:organizations, params: {search: "#{field} = \"#{name_or_label}\""},
                                          returns: {'id' => id}).at_least_once
  end
end
