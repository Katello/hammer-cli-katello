module ContentExportHelpers
  def expects_repositories_in_library(organization_id, returns = [])
    export_task = api_expects(:repositories, :index) do |p|
      assert_equal organization_id.to_s, p[:organization_id].to_s
      assert p[:library]
      assert_equal "download_policy != immediate", p[:search]
      assert_equal "yum", p[:content_type]
    end
    export_task.returns(index_response(returns))
  end

  def expects_repositories_in_version(version_id, returns = [])
    export_task = api_expects(:repositories, :index) do |p|
      assert_equal version_id.to_s, p[:content_view_version_id].to_s
      assert p[:library]
      assert_equal "download_policy != immediate", p[:search]
      assert_equal "yum", p[:content_type]
    end
    export_task.returns(index_response(returns))
  end
end
