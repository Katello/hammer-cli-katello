module SyncPlanHelpers
  def expect_sync_plan_search(org_id, name, id)
    ex = api_expects(:sync_plans, :index, 'find sync plan') do |par|
      par['name'] == name && par['organization_id'] == org_id
    end
    ex.returns(index_response([{'id' => id}]))
  end
end
