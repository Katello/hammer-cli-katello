require File.join(File.dirname(__FILE__), '../test_helper')

describe 'verify checksum on a product' do
  include ForemanTaskHelpers

  before do
    @cmd = %w(product verify-checksum)
  end

  let(:sync_response) do
    {
      'id' => '1',
      'state' => 'planned'
    }
  end

  it 'verifies products ' do
    params = [
      '--ids=1'
    ]

    ex = api_expects(:products_bulk_actions, :verify_checksum_products, 'verify checksum')
         .with_params('ids' => [1])
    ex.returns(sync_response)

    expect_foreman_task('3')

    result = run_cmd(@cmd + params)
    assert_equal(HammerCLI::EX_OK, result.exit_code)
  end
end
