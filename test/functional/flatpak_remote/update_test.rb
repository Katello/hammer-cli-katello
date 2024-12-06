require File.join(File.dirname(__FILE__), '../test_helper')

describe 'Updating flatpak remotes' do
  before do
    @cmd = %w(flatpak-remote update)
  end

  let(:id) { 1 }
  let(:desc) { 'A flatpak remote for Fedora registry' }

  it 'updates flatpak remote' do
    params = ["--id=#{id}", "--description=#{desc}"]

    ex = api_expects(:flatpak_remotes, :update, 'flatpak remote update') do |par|
      par['id'] == 1 && par['description'] == 'A flatpak remote for Fedora registry'
    end

    ex.returns({})

    result = run_cmd(@cmd + params)
    assert_equal(result.exit_code, 0)
  end
end
