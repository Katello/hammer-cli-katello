require File.join(File.dirname(__FILE__), '../test_helper')
require File.join(File.dirname(__FILE__), '../product/product_helpers')
require File.join(File.dirname(__FILE__), './repository_helpers')

describe 'upload repository' do
  include ProductHelpers
  include RepositoryHelpers
  include ForemanTaskHelpers

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
      par[:id] == repo_id && par[:uploads] == [upload] && par[:sync_capsule] == true &&
        par[:publish_repository] == true
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
      par[:id] == repo_id && par[:uploads] == [upload] && par[:sync_capsule] == true &&
        par[:publish_repository] == true
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

  it "supports globs" do
    File.new("test.rpm", "w")

    params = ["--id=#{repo_id}", "--path={test}.[r{1}]pm"]

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
      par[:id] == repo_id && par[:uploads] == [upload] && par[:sync_capsule] == true &&
        par[:publish_repository] == true
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

  it "only syncs the capsule on the last file import" do
    File.new("test1.rpm", "w")
    File.new("test2.rpm", "w")

    params = ["--id=#{repo_id}", "--path=test*.rpm"]

    # Begin first upload cycle

    ex = api_expects(:content_uploads, :create, "Create upload for content") do |par|
      par[:repository_id] == repo_id
    end

    ex.returns(upload_response)

    ex = api_expects(:repositories, :import_uploads, 'Take in an upload') do |par|
      par[:id] == repo_id && par[:uploads].one? && par[:sync_capsule] == false &&
        par[:publish_repository] == false
    end

    ex.returns("")

    ex = api_expects(:content_uploads, :destroy, "Delete the upload") do |par|
      par[:id] == upload_id && par[:repository_id] == repo_id
    end

    ex.returns("")

    # Begin second upload cycle

    ex = api_expects(:content_uploads, :create, "Create upload for content") do |par|
      par[:repository_id] == repo_id
    end

    ex.returns(upload_response)

    ex = api_expects(:repositories, :import_uploads, 'Take in an upload') do |par|
      par[:id] == repo_id && par[:uploads].one? && par[:sync_capsule] == true &&
        par[:publish_repository] == true
    end

    ex.returns("")

    ex = api_expects(:content_uploads, :destroy, "Delete the upload") do |par|
      par[:id] == upload_id && par[:repository_id] == repo_id
    end

    ex.returns("")

    result = run_cmd(@cmd + params)
    assert_equal(result.exit_code, 0)
    File.delete("test1.rpm")
    File.delete("test2.rpm")
  end

  it "errors if there are no matching files" do
    params = ["--id=#{repo_id}", "--path=#{path}"]

    result = run_cmd(@cmd + params)

    assert_equal "Could not find any files matching PATH\n", result.err
    assert_equal HammerCLI::EX_NOINPUT, result.exit_code
  end

  describe 'requires' do
    it 'repository options' do
      api_expects_no_call
      error = run_cmd(@cmd + %W(--path #{path})).err
      assert error.include?('--id, --name is required'), "Actual result: #{error}"
    end

    it 'product options when repository name is specified' do
      api_expects_no_call
      error = run_cmd(@cmd + %W(--name repo1 --path #{path})).err
      assert(error.include?('--product, --product-id is required'), "Actual result: #{error}")
    end

    it 'organization options when product name is specified' do
      api_expects_no_call
      error = run_cmd(@cmd + %W(--name repo1 --product product2 --path #{path})).err
      assert(error.include?('--organization-id, --organization, --organization-label is required'),
             "Actual result: #{error}")
    end
  end

  describe 'disallows' do
    it 'product options when repository ID is specified' do
      api_expects_no_call
      error = run_cmd(@cmd + %W(--id 1 --product product2 --path #{path})).err
      assert(error.include?('Cannot specify both product options and repository ID'),
             "Actual result: #{error}")
    end
  end
end
