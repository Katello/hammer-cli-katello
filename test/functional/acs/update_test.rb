require File.join(File.dirname(__FILE__), '../test_helper')

describe 'listing acs' do
  before do
    @cmd = %w(alternate-content-source update)
  end

  let(:id) { 1 }
  let(:desc) { 'pizza' }

  it 'update acs' do
    params = ["--id=#{id}", "--description=#{desc}"]

    ex = api_expects(:alternate_content_sources, :update, 'acs update') do |par|
      par['id'] == 1 && par['description'] == 'pizza'
    end

    ex.returns({})

    result = run_cmd(@cmd + params)
    assert_equal(result.exit_code, 0)
  end
end
