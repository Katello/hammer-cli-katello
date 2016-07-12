module ContentViewHelpers
  def expect_content_view_search(org_id, name, id)
    ex = api_expects(:content_views, :index, 'Find the content view') do |par|
      par['name'] == name && par['organization_id'] == org_id
    end
    ex.returns(index_response([{'id' => id}]))
  end

  def expect_content_view_index(checks, returns)
    ex = api_expects(:content_views, :index) do |par|
      checks.inject(true) do |result, check|
        result && par[check[0]] == check[1]
      end
    end
    ex.returns(index_response([returns]))
  end
end
