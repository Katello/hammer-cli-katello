require File.join(File.dirname(__FILE__), '../test_helper')

describe 'delete an acs' do
  let(:id) { 1 }

  it 'by id' do
    api_expects(:alternate_content_sources, :destroy, 'delete acs').
      with_params('id' => id)

    command = %W(alternate-content-source delete --id #{id})
    assert_equal(0, run_cmd(command).exit_code)
  end
end
