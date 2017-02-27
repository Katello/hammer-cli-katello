module HammerCLIKatello
  module ContentAPIExpectations
    ORGANIZATION_ID = 1
    HOST_COLLECTION_ID = 3
    HOST_COLLECTION_NAME = 'Test'.freeze

    def host_collection
      {
        'id' => HOST_COLLECTION_ID,
        'name' => HOST_COLLECTION_NAME
      }
    end

    def api_expects_content_action(action, content_type, expected_params)
      expected_params[:organization_id] ||= ORGANIZATION_ID
      expected_params[:host_collection_id] ||= HOST_COLLECTION_ID

      api_expects(:hosts_bulk_actions, action) do |p|
        search_query = "host_collection_id=\"#{expected_params[:host_collection_id]}\""
        p['organization_id'] == expected_params[:organization_id] &&
          p['included'] == { search: search_query } &&
          p['content'] == expected_params[:content] &&
          p['content_type'] == content_type
      end
    end

    def api_expects_collection_search
      expectation = api_expects(:host_collections, :index) do |p|
        p["name"] == HOST_COLLECTION_NAME &&
          p["organization_id"] == ORGANIZATION_ID
      end
      expectation.returns(index_response([host_collection]))
    end
  end
end
