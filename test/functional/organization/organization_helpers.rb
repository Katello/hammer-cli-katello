module OrganizationHelpers
  def expect_organization_search(name, id)
    ex = api_expects(:organizations, :index, 'Find the organization') do |par|
      par[:search] == "name = \"#{name}\""
    end
    ex.at_least_once.returns(index_response([{'id' => id}]))
  end
end
