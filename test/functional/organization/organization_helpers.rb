module OrganizationHelpers
  def expect_organization_search(name_or_label, id, field: 'name')
    ex = api_expects(:organizations, :index, 'Find the organization') do |par|
      par[:search] == "#{field} = \"#{name_or_label}\""
    end
    ex.at_least_once.returns(index_response([{'id' => id}]))
  end
end
