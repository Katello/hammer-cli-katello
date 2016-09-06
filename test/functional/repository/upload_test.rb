require File.join(File.dirname(__FILE__), '../test_helper')
require File.join(File.dirname(__FILE__), '../product/product_helpers')
require File.join(File.dirname(__FILE__), './repository_helpers')

describe 'upload repository' do
  include ProductHelpers
  include RepositoryHelpers

  before do
    @cmd = %w(repository upload-content)
  end

  let(:org_id) { 1 }
  let(:product_id) { 2 }
  let(:repo_id) { 3 }
  let(:path) { "./test.rpm" }
  let(:upload_id) { "1234" }
  let(:_href) { "/pulp/api/v2/content/uploads/#{upload_id}" }
  let(:upload_response) do
    {
      "upload_id" => upload_id,
      "_href" => _href
    }
  end

  it "uploads a package" do
    File.new("test.rpm", "w")

    params = ["--id=#{repo_id}", "--path=#{path}"]

    ex = api_expects(:content_uploads, :create, "Create upload for content") do |par|
      par[:repository_id] == repo_id.to_s
    end

    ex.returns(upload_response)

    ex2 = api_expects(:repositories, :import_uploads, 'Take in an upload') do |par|
      upload = {
        :id => '1234',
        :name => 'test.rpm',
        :size => 0,
        :checksum => 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'
      }
      par[:id] == repo_id.to_s && par[:uploads] == [upload]
    end

    ex2.returns("")

    ex3 = api_expects(:content_uploads, :destroy, "Delete the upload") do |par|
      par[:id] == upload_id && par[:repository_id] == repo_id.to_s
    end

    ex3.returns("")

    result = run_cmd(@cmd + params)
    assert_equal(result.exit_code, 0)
    File.delete("test.rpm")
  end

  it "uploads a package with an organization-id" do
    File.new("test.rpm", "w")

    params = ["--name=test_repo", "--product=test_product", "--organization-id=#{org_id}",
              "--path=#{path}"]

    expect_product_search(org_id, 'test_product', product_id)

    expect_repository_search(product_id, 'test_repo', repo_id)

    ex = api_expects(:content_uploads, :create, "Create upload for content") do |par|
      par[:repository_id] == repo_id
    end

    ex.returns(upload_response)

    ex2 = api_expects(:repositories, :import_uploads, 'Take in an upload') do |par|
      upload = {
        :id => '1234',
        :name => 'test.rpm',
        :size => 0,
        :checksum => 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'
      }
      par[:id] == repo_id && par[:uploads] == [upload]
    end

    ex2.returns("")

    ex3 = api_expects(:content_uploads, :destroy, "Delete the upload") do |par|
      par[:id] == upload_id && par[:repository_id] == repo_id
    end

    ex3.returns("")

    result = run_cmd(@cmd + params)
    assert_equal(result.exit_code, 0)
    File.delete("test.rpm")
  end
end
