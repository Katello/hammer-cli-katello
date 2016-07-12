module LifecycleEnvironmentHelpers
  def expect_lifecycle_environment_search(org_id, name, id)
    ex = api_expects(:lifecycle_environments, :index, 'Find the lifecycle environment') do |par|
      par['name'] == name && par['organization_id'] == org_id
    end
    ex.returns(index_response([{'id' => id}]))
  end

  def expect_lifecycle_environments_request(org_id, results)
    ex = api_expects(:lifecycle_environments, :index, 'List the lifecycle environments') do |par|
      par['organization_id'] == org_id
    end
    ex.returns(index_response(results))
  end

  def expect_lifecycle_environment_index(checks, returns)
    ex = api_expects(:lifecycle_environments, :index) do |par|
      checks.inject(true) do |result, check|
        result && par[check[0]] == check[1]
      end
    end
    ex.returns(index_response([returns]))
  end
end
