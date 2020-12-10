require_relative '../search_helpers'

module LifecycleEnvironmentHelpers
  include SearchHelpers

  def expect_lifecycle_environment_search(org_id, name, id)
    expect_lenient_search(:lifecycle_environments,
                          params: {'name' => name, 'organization_id' => org_id},
                          returns: {'id' => id})
  end

  def expect_lifecycle_environments_request(org_id, results)
    ex = api_expects(:lifecycle_environments, :index, 'List the lifecycle environments') do |par|
      par['organization_id'] == org_id
    end
    ex.returns(index_response(results))
  end
end
