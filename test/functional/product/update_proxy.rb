require File.join(File.dirname(__FILE__), '../test_helper')

describe 'update an http proxy on a product' do
  include ForemanTaskHelpers

  before do
    @cmd = %w(product update-proxy)
  end

  let(:sync_response) do
    {
      'id' => 1,
      'state' => 'planned',
      'action' => 'Update http proxy'
    }
  end

  it 'updates product proxy policy' do
    params = [
      '--ids=1',
      '--http-proxy-policy=use_selected_http_proxy',
      '--http-proxy-id=1'
    ]

    ex = api_expects(:products_bulk_actions, :update_http_proxy, 'update an http-proxy')
         .with_params('ids' => '1', 'http_proxy_policy' => 'use_selected_http_proxy',
                      'http_proxy_id' => '1')
    ex.returns(sync_response)

    expect_foreman_task('3')

    result = run_cmd(@cmd + params)
    assert_equal(HammerCLI::EX_OK, result.exit_code)
  end

  it 'fails with missing required params' do
    params = ['--proxy-id=1']

    ex = api_expects(:products_bulk_actions, :update_http_proxy, 'update an http-proxy')
         .with_params('proxy_id' => '1')
    ex.returns(
      'proxy_id' => '1'
    )

    result = run_cmd(@cmd + params)
    assert_equal(result.exit_code, 70)
  end
end
