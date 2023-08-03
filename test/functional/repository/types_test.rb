require File.join(File.dirname(__FILE__), '../test_helper')

describe 'repository types' do
  before do
    @cmd = %w[repository types]
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

  let(:types_response) do
    {
      "results" => [
        {
          "name": "file",
          "id": "file",
          "creatable": true,
          "pulp3_support": true,
          "generic_remote_options": [],
          "import_attributes": [],
          "url_description": nil,
          "content_types": [
            {
              "label": "file",
              "generic_browser": nil,
              "generic": false,
              "removable": true,
              "uploadable": true,
              "indexed": true
            }
          ]
        },
        {
          "name": "yum",
          "id": "yum",
          "creatable": true,
          "pulp3_support": true,
          "generic_remote_options": [],
          "import_attributes": [],
          "url_description": nil,
          "content_types": [
            {
              "label": "rpm",
              "generic_browser": nil,
              "generic": false,
              "removable": true,
              "uploadable": true,
              "indexed": true
            },
            {
              "label": "modulemd",
              "generic_browser": nil,
              "generic": false,
              "removable": false,
              "uploadable": false,
              "indexed": true
            }
          ]
        }
      ]
    }
  end

  it "lists repository types and returns empty response" do
    ex = api_expects(:repositories, :repository_types, 'repository types')

    ex.returns(empty_response)

    expected_result = success_result("\n\n")

    result = run_cmd(@cmd)
    assert_cmd(expected_result, result)
  end

  it "lists repository types and returns response" do
    ex = api_expects(:repositories, :repository_types, 'repository types')

    ex.returns(types_response)
    # rubocop:disable Style/TrailingWhitespace
    expected_result = success_result("Name:          file
Content types: 
 1) Type:        file
    Generic?:    false
    Removable?:  true
    Uploadable?: true
    Indexed?:    true

Name:          yum
Content types: 
 1) Type:        rpm
    Generic?:    false
    Removable?:  true
    Uploadable?: true
    Indexed?:    true
 2) Type:        modulemd
    Generic?:    false
    Removable?:  false
    Uploadable?: false
    Indexed?:    true

")
    # rubocop:enable Style/TrailingWhitespace
    result = run_cmd(@cmd)
    assert_cmd(expected_result, result)
  end
end
