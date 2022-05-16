require File.join(File.dirname(__FILE__), '../test_helper')
require File.join(File.dirname(__FILE__), '../product/product_helpers')
require File.join(File.dirname(__FILE__), './repository_helpers')
require 'hammer_cli_katello/associating_commands'

describe "get repository info" do
  include ProductHelpers
  include RepositoryHelpers

  before do
    @cmd = %w(repository info)
  end

  it "shows repository info by id" do
    params = ['--id=1']
    ex = api_expects(:repositories, :show, "Get info")
    ex.returns(
      'id' => 1,
      'name' => 'Test Repo',
      'label' => 'Test_Repo',
      'description' => 'hammertime',
      'organization' => {
        'name' => 'Default Organization',
        'label' => 'Default_Organization',
        'id' => 1
      },
      'created_at' => '2020-08-05 15:35:36 UTC',
      'updated_at' => '2020-08-05 15:35:36 UTC',
      'content_type' => 'yum',
      'product' => {
        'id' => 79,
        'name' => 'test'
      },
      'download_policy' => 'immediate',
      'unprotected' => true,
      'last_sync_words' => '3 minutes',
      'mirroring_policy' => 'additive',
      'relative_path' => 'Default_Organization/Library/Test_Repo',
      'content_counts' => {
        'rpm' => 1,
        'srpm' => 0,
        'package_group' => 0,
        'erratum' => 1,
        'module_stream' => 0
      }
    )
    result = run_cmd(@cmd + params)
    # rubocop:disable Style/WordArray
    expected_fields = [['Id', '1'],
                       ['Name', 'Test Repo'],
                       ['Label', 'Test_Repo'],
                       ['Description', 'hammertime'],
                       ['Organization', 'Default Organization'],
                       ['Red Hat Repository', 'no'],
                       ['Content Type', 'yum'],
                       ['Mirroring Policy', 'Additive'],
                       ['Publish Via HTTP', 'yes'],
                       ['Relative Path', 'Default_Organization/Library/Test_Repo'],
                       ['Download Policy', 'immediate'],
                       ['HTTP Proxy', ''],
                       ['Product', ''],
                       ['Id', '79'],
                       ['Name', 'test'],
                       ['GPG Key', ''],
                       ['Sync', ''],
                       ['Status', 'Not Synced'],
                       ['Last Sync Date', '3 minutes'],
                       ['Created', '2020/08/05 15:35:36'],
                       ['Updated', '2020/08/05 15:35:36'],
                       ['Content Counts', ''],
                       ['Packages', '1'],
                       ['Source RPMS', '0'],
                       ['Package Groups', '0'],
                       ['Errata', '1'],
                       ['Module Streams', '0']]
    # rubocop:enable Style/WordArray
    expected_results = expected_fields.map { |field| success_result(FieldMatcher.new(*field)) }
    expected_results.each { |expected|  assert_cmd(expected, result) }
  end

  it "Shows information about a repository with organization-id and product name" do
    org_id = 1
    product_id = 2
    repo_id = 3
    params = ["--name=Test_Repo", "--product=Test_Product", "--organization-id=1"]

    expect_product_search(org_id, 'Test_Product', product_id)

    expect_repository_search(product_id, 'Test_Repo', repo_id)

    ex = api_expects(:repositories, :show, "Get info")

    ex.returns(
      'id' => 1,
      'name' => 'Test Repo',
      'label' => 'Test_Repo',
      'description' => 'hammertime',
      'organization' => {
        'name' => 'Default Organization',
        'label' => 'Default_Organization',
        'id' => 1
      },
      'created_at' => '2020-08-05 15:35:36 UTC',
      'updated_at' => '2020-08-05 15:35:36 UTC',
      'content_type' => 'yum',
      'product' => {
        'id' => 79,
        'name' => 'Test_Product'
      },
      'download_policy' => 'immediate',
      'unprotected' => true,
      'last_sync_words' => '3 minutes',
      'mirroring_policy' => 'mirror_complete',
      'relative_path' => 'Default_Organization/Library/Test_Repo',
      'content_counts' => {
        'rpm' => 1,
        'srpm' => 0,
        'package_group' => 0,
        'erratum' => 1,
        'module_stream' => 0
      }
    )
    result = run_cmd(@cmd + params)
    # rubocop:disable Style/WordArray
    expected_fields = [['Id', '1'],
                       ['Name', 'Test Repo'],
                       ['Label', 'Test_Repo'],
                       ['Description', 'hammertime'],
                       ['Organization', 'Default Organization'],
                       ['Red Hat Repository', 'no'],
                       ['Content Type', 'yum'],
                       ['Mirroring Policy', 'Complete Mirroring'],
                       ['Publish Via HTTP', 'yes'],
                       ['Relative Path', 'Default_Organization/Library/Test_Repo'],
                       ['Download Policy', 'immediate'],
                       ['HTTP Proxy', ''],
                       ['Product', ''],
                       ['Id', '79'],
                       ['Name', 'Test_Product'],
                       ['GPG Key', ''],
                       ['Sync', ''],
                       ['Status', 'Not Synced'],
                       ['Last Sync Date', '3 minutes'],
                       ['Created', '2020/08/05 15:35:36'],
                       ['Updated', '2020/08/05 15:35:36'],
                       ['Content Counts', ''],
                       ['Packages', '1'],
                       ['Source RPMS', '0'],
                       ['Package Groups', '0'],
                       ['Errata', '1'],
                       ['Module Streams', '0']]
    # rubocop:enable Style/WordArray
    expected_results = expected_fields.map { |field| success_result(FieldMatcher.new(*field)) }
    expected_results.each { |expected|  assert_cmd(expected, result) }
  end
end
