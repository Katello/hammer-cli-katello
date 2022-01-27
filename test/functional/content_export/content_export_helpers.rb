require_relative '../search_helpers'

module ContentExportHelpers
  include SearchHelpers
  def expects_repository(repository_id, returns = {})
    ex = api_expects(:repositories, :show, "Find Repo #{repository_id}") do |p|
      assert_equal p[:id].to_s, repository_id.to_s
    end
    ex.returns(returns)
  end

  def expects_repositories_in_library(organization_id, returns = [])
    expect_lenient_search(:repositories,
                          params: {
                            organization_id: organization_id,
                            library: true,
                            search: "download_policy != immediate",
                            content_type: 'yum'
                          },
                          returns: returns)
  end

  def expects_repositories_in_version(version_id, returns = [])
    expect_lenient_search(:repositories,
                          params: {
                            content_view_version_id: version_id,
                            library: true,
                            search: "download_policy != immediate",
                            content_type: 'yum'
                          },
                          returns: returns)
  end
end
