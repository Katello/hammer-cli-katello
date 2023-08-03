require File.join(File.dirname(__FILE__), '../test_helper')

describe 'listing available product content' do
  let(:activation_key_id) { 1 }
  let(:empty_response_table) do
    <<~EOSTRING
      ---|------|------|-----|---------|-------|------------------|---------
      ID | NAME | TYPE | URL | GPG KEY | LABEL | DEFAULT ENABLED? | OVERRIDE
      ---|------|------|-----|---------|-------|------------------|---------
    EOSTRING
  end

  it "lists content available for an activation key" do
    ex = api_expects(:activation_keys, :product_content) do |p|
      p['id'] = activation_key_id
    end
    ex.returns(index_response([]))
    assert_cmd(
      success_result(empty_response_table),
      run_cmd(%w[activation-key product-content --id 1])
    )
  end
end
