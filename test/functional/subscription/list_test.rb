require File.join(File.dirname(__FILE__), '../test_helper')

describe 'listing content-views' do
  before do
    @cmd = %w(subscription list)
  end

  let(:org_id) { 1 }

  it "lists an organizations subscriptions" do
    params = ["--organization-id=#{org_id}"]

    ex = api_expects(:subscriptions, :index, 'Subscription list') do |par|
      par['organization_id'] == org_id
    end

    ex.returns(index_response([]))

    result = run_cmd(@cmd + params)

    fields = ['ID', 'UUID', 'NAME', 'CONTRACT', 'ACCOUNT', 'SUPPORT', 'QUANTITY', 'CONSUMED',
              'END DATE', 'QUANTITY', 'ATTACHED']
    expected_result = success_result(IndexMatcher.new([fields, []]))
    assert_cmd(expected_result, result)
  end
end
