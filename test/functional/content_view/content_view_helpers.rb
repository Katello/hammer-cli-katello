module ContentViewHelpers
  def expect_content_view_search(org_id, name, id)
    ex = api_expects(:content_views, :index, 'Find the content view') do |par|
      par['name'] == name && par['organization_id'] == org_id
    end
    ex.returns(index_response([{'id' => id}]))
  end
end
