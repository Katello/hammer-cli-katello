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
  let(:task_id) { "2ea4f" }
  let(:upload_response) do
    {
      "upload_id" => upload_id,
      "href" => _href
    }
  end
  let(:import_uploads_response) do
    {
      "id" => task_id
    }
  end

  it "uploads a package" do
    file = File.new("test.rpm", "w")

    params = ["--id=#{repo_id}", "--path=#{path}"]

    ex = api_expects(:content_uploads, :create, "Create upload for content")
         .with_params('repository_id' => repo_id, :size => file.size)

    ex.returns(upload_response)

    ex2 = api_expects(:repositories, :import_uploads, 'Take in an upload')
          .with_params(:id => repo_id, :sync_capsule => true, :publish_repository => true, :async => true,
                       :uploads => [{
                         :id => '1234',
                         :name => 'test.rpm',
                         :size => 0,
                         :content_unit_id => nil,
                         :checksum => 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'
                       }]
                      )

    ex2.returns(import_uploads_response)
    expect_foreman_task(task_id)
    expect_foreman_task(task_id)

    ex3 = api_expects(:content_uploads, :destroy, "Delete the upload")
          .with_params('id' => upload_id, 'repository_id' => repo_id)

    ex3.returns("")
    result = run_cmd(@cmd + params)

    assert_equal(result.exit_code, 0)
    File.delete("test.rpm")
  end

  it "uploads srpm with content-type" do
    file = File.new("test.src.rpm", "w")
    params = ["--id=#{repo_id}", '--path=./test.src.rpm', '--content-type=srpm']

    ex = api_expects(:content_uploads, :create, "Create upload for content")
         .with_params('repository_id' => repo_id, :content_type => 'srpm', :size => file.size)

    ex.returns(upload_response)

    ex2 = api_expects(:repositories, :import_uploads, 'Take in an upload')
          .with_params(:id => repo_id, :sync_capsule => true, :publish_repository => true, :content_type => 'srpm', :async => true,
                       :uploads => [{
                         :id => '1234',
                         :name => 'test.src.rpm',
                         :size => 0,
                         :content_unit_id => nil,
                         :checksum => 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'
                       }]
                      )

    ex2.returns(import_uploads_response)
    expect_foreman_task(task_id)
    expect_foreman_task(task_id)

    ex3 = api_expects(:content_uploads, :destroy, "Delete the upload")
          .with_params(:id => upload_id, :repository_id => repo_id)

    ex3.returns("")

    result = run_cmd(@cmd + params)
    assert_equal(result.exit_code, 0)
    File.delete("test.src.rpm")
  end

  it 'fails upload of srpm with no content-type' do
    file = File.new("test.src.rpm", "w")

    params = ["--id=#{repo_id}", '--path=./test.src.rpm']

    ex = api_expects(:content_uploads, :create, "Create upload for content")
         .with_params('repository_id' => repo_id, :size => file.size)

    ex.returns(upload_response)

    ex2 = api_expects(:repositories, :import_uploads, 'Take in an upload')
          .with_params(:id => repo_id, :sync_capsule => true, :publish_repository => true, :async => true,
                       :uploads => [{
                         :id => '1234',
                         :name => 'test.src.rpm',
                         :size => 0,
                         :content_unit_id => nil,
                         :checksum => 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'
                       }]
                      )

    ex2.returns(400)

    ex3 = api_expects(:content_uploads, :destroy, "Delete the upload")
          .with_params(:id => upload_id, :repository_id => repo_id)

    ex3.returns("")

    result = run_cmd(@cmd + params)
    assert_equal(result.exit_code, 70)
    File.delete("test.src.rpm")
  end

  it "uploads a docker image" do
    file = File.new("test.rpm", "w")

    params = ["--id=#{repo_id}", "--path=#{path}"]

    ex = api_expects(:content_uploads, :create, "Create upload for content")
         .with_params(:repository_id => repo_id, :size => file.size)

    ex.returns(upload_response)

    ex2 = api_expects(:repositories, :import_uploads, 'Take in an upload')
          .with_params(:id => repo_id, :sync_capsule => true, :publish_repository => true, :async => true,
                       :uploads => [{
                         :id => '1234',
                         :name => 'test.rpm',
                         :size => 0,
                         :content_unit_id => nil,
                         :checksum => 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'
                       }]
                      )

    ex2.returns(import_uploads_response)
    expect_foreman_task(task_id)

    ex3 = api_expects(:foreman_tasks, :show, 'Show task')
    ex3.returns('id' => task_id, 'state' => 'stopped', 'progress' => 1,
                'humanized' => {'output' => {'upload_results' => [{'type' => 'docker_manifest',
                                                                   'digest' => 'sha256:1234'}]},
                                'errors' => ''})

    ex4 = api_expects(:content_uploads, :destroy, "Delete the upload")
          .with_params(:id => upload_id, :repository_id => repo_id)

    ex4.returns("")

    result = run_cmd(@cmd + params)
    assert_equal(result.exit_code, 0)
    File.delete("test.rpm")
  end

  it "uploads a package with an organization-id" do
    file = File.new("test.rpm", "w")

    params = ["--name=test_repo", "--product=test_product", "--organization-id=#{org_id}",
              "--path=#{path}"]

    expect_product_search(org_id, 'test_product', product_id)

    expect_repository_search(product_id, 'test_repo', repo_id)

    ex = api_expects(:content_uploads, :create, "Create upload for content")
         .with_params(:repository_id => repo_id, :size => file.size)

    ex.returns(upload_response)

    ex2 = api_expects(:repositories, :import_uploads, 'Take in an upload')
          .with_params(:id => repo_id, :sync_capsule => true, :publish_repository => true, :async => true,
                       :uploads => [{
                         :id => '1234',
                         :name => 'test.rpm',
                         :size => 0,
                         :content_unit_id => nil,
                         :checksum => 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'
                       }]
                      )

    ex2.returns(import_uploads_response)
    expect_foreman_task(task_id)
    expect_foreman_task(task_id)

    ex3 = api_expects(:content_uploads, :destroy, "Delete the upload")
          .with_params(:id => upload_id, :repository_id => repo_id)

    ex3.returns("")

    result = run_cmd(@cmd + params)
    assert_equal(result.exit_code, 0)
    File.delete("test.rpm")
  end

  it "supports globs" do
    file = File.new("test.rpm", "w")

    params = ["--id=#{repo_id}", "--path={test}.[r{1}]pm"]

    ex = api_expects(:content_uploads, :create, "Create upload for content")
         .with_params(:repository_id => repo_id, :size => file.size)

    ex.returns(upload_response)
    ex2 = api_expects(:repositories, :import_uploads, 'Take in an upload')
          .with_params(:id => repo_id, :sync_capsule => true, :publish_repository => true, :async => true,
                       :uploads => [{
                         :id => '1234',
                         :name => 'test.rpm',
                         :size => 0,
                         :content_unit_id => nil,
                         :checksum => 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'
                       }]
                      )
    ex2.returns(import_uploads_response)
    expect_foreman_task(task_id)
    expect_foreman_task(task_id)

    ex3 = api_expects(:content_uploads, :destroy, "Delete the upload")
          .with_params(:id => upload_id, :repository_id => repo_id)

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

    ex = api_expects(:content_uploads, :create, "Create upload for content")
         .with_params(:repository_id => repo_id)

    ex.returns(upload_response)

    ex = api_expects(:repositories, :import_uploads, 'Take in an upload')
         .with_params(:id => repo_id, :sync_capsule => false, :publish_repository => false, :async => true,
                      :uploads => [{
                        :id => '1234',
                        :name => 'test1.rpm',
                        :size => 0,
                        :content_unit_id => nil,
                        :checksum => 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'
                      }]
                     )

    ex.returns(import_uploads_response)
    expect_foreman_task(task_id)
    expect_foreman_task(task_id)

    ex = api_expects(:content_uploads, :destroy, "Delete the upload")
         .with_params(:id => upload_id, :repository_id => repo_id)

    ex.returns("")

    # Begin second upload cycle

    ex = api_expects(:content_uploads, :create, "Create upload for content")
         .with_params(:repository_id => repo_id)

    ex.returns(upload_response)

    ex = api_expects(:repositories, :import_uploads, 'Take in an upload')
         .with_params(:id => repo_id, :sync_capsule => true, :publish_repository => true, :async => true,
                      :uploads => [{
                        :id => '1234',
                        :name => 'test2.rpm',
                        :size => 0,
                        :content_unit_id => nil,
                        :checksum => 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'
                      }]
                     )

    ex.returns(import_uploads_response)
    expect_foreman_task(task_id)
    expect_foreman_task(task_id)

    ex = api_expects(:content_uploads, :destroy, "Delete the upload")
         .with_params(:id => upload_id, :repository_id => repo_id)

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
