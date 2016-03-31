module LifecycleEnvironmentHelpers

  def expect_lifecycle_environment_search(org_id, name, id)
    ex = api_expects(:lifecycle_environments, :index, 'Find the lifecycle environment') do |par|
      par['name'] == name && par['organization_id'] == org_id
    end
    ex.returns(index_response([{'id' => id}]))
  end

end
