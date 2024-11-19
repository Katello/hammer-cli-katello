require File.join(File.dirname(__FILE__), '../test_helper')

describe 'delete a flatpak remote' do
  let(:id) { 1 }

  it 'by id' do
    api_expects(:flatpak_remotes, :destroy, 'delete acs').
      with_params('id' => id)

    command = %W(flatpak-remote delete --id #{id})
    assert_equal(0, run_cmd(command).exit_code)
  end
end
