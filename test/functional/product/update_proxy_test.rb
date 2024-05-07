require File.join(File.dirname(__FILE__), '../test_helper')

describe 'update an http proxy on a product' do
  include ForemanTaskHelpers

  before do
    @cmd = %w(product update-proxy)
  end

  let(:sync_response) do
    {
      'id' => '1',
      'state' => 'planned'
    }
  end

  it 'updates product proxy policy' do
    params = [
      '--ids=1',
      '--http-proxy-policy=use_selected_http_proxy',
      '--http-proxy-id=1'
    ]

    ex = api_expects(:products_bulk_actions, :update_http_proxy, 'update an http-proxy')
         .with_params("ids" => [1], "http_proxy_policy" => "use_selected_http_proxy",
                      "http_proxy_id" => 1)
    ex.returns(sync_response)

    expect_foreman_task('3')

    result = run_cmd(@cmd + params)
    assert_equal(HammerCLI::EX_OK, result.exit_code)
  end

  it 'fails with missing required params' do
    params = ['--http-proxy-id=1']
    api_expects_no_call
    result = run_cmd(@cmd + params)
    assert(result.err[/--ids is required/],
       "ids requirements must be validated")
  end
end
