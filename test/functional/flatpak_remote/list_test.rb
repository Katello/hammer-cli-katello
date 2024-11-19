require File.join(File.dirname(__FILE__), '../test_helper')

describe 'listing flatpak remotes' do
  before do
    @cmd = %w(flatpak-remote list)
  end

  let(:empty_response) do
    {
      "total" => 0,
      "subtotal" => 0,
      "page" => "1",
      "per_page" => "1000",
      "error" => nil,
      "search" => nil,
      "sort" => {
        "by" => nil,
        "order" => nil
      },
      "results" => []
    }
  end

  let(:flatpak_response) do
    {
      'id' => 1,
      'name' => 'Fedora flatpak',
      'url' => 'https://registry.fedoraproject.org/',
      'organization_id' => 1,
      'username' => nil,
      'token' => nil,
    }
  end

  it "lists flatpak remotes and returns empty response" do
    ex = api_expects(:flatpak_remotes, :index, 'flatpak list') do |par|
      par['page'] == 1 && par['per_page'] == 1000
    end

    ex.returns(empty_response)

    expected_result = success_result("---|------|-----|-------------|----------|-------------
ID | NAME | URL | DESCRIPTION | USERNAME | REGISTRY URL
---|------|-----|-------------|----------|-------------
")

    result = run_cmd(@cmd)
    assert_cmd(expected_result, result)
  end

  it "lists flatpak remotes and returns response" do
    ex = api_expects(:flatpak_remotes, :index, 'flatpak list') do |par|
      par['page'] == 1 && par['per_page'] == 1000
    end

    ex.returns(flatpak_response)
    expected_result = success_result("1  | Fedora flatpak | https://registry.fedoraproject.org/ |" + "         " + "
---|----------------|-------------------------------------|---------\n"
                                    )
    result = run_cmd(@cmd)
    assert_cmd(expected_result, result)
  end
end
