require_relative '../test_helper'
require_relative '../organization/organization_helpers'
require 'hammer_cli_katello/repository'

# rubocop:disable ModuleLength
module HammerCLIKatello
  describe Repository::UpdateCommand do
    include OrganizationHelpers

    it 'allows minimal options' do
      api_expects(:repositories, :update) do |p|
        p['id'] == 1 && p['name'] == 'rep1'
      end

      run_cmd(%w(repository update --id 1 --new-name rep1))
    end

    describe 'resolves repository ID' do
      it 'by requiring product' do
        api_expects_no_call
        result = run_cmd(%w(repository update --name repo1 --new-name rep1))
        assert(result.err[/--product, --product-id is required/], 'Incorrect error message')
      end

      it 'by product ID' do
        ex = api_expects(:repositories, :index) do |p|
          p['name'] == 'repo1' && p['product_id'] == 3
        end
        ex.returns(index_response([{'id' => 1}]))

        api_expects(:repositories, :update) do |p|
          p['id'] == 1 && p['name'] == 'rep1'
        end

        run_cmd(%w(repository update --name repo1 --product-id 3 --new-name rep1))
      end
    end

    describe 'resolves product ID' do
      it 'by requiring organization options' do
        api_expects_no_call
        result = run_cmd(%w(repository update --name repo1 --product prod1 --new-name rep1))
        assert(result.err[/--organization-id, --organization, --organization-label is required/],
               "Organization option requirements must be validated")
      end

      it 'by organization ID' do
        ex = api_expects(:products, :index) do |p|
          p['name'] == 'prod3' && p['organization_id'] == '5'
        end
        ex.returns(index_response([{'id' => 3}]))

        ex = api_expects(:repositories, :index) do |p|
          p['name'] == 'repo1' && p['product_id'] == 3
        end
        ex.returns(index_response([{'id' => 1}]))

        api_expects(:repositories, :update) do |p|
          p['id'] == 1 && p['name'] == 'rep1'
        end

        run_cmd(%w(repository update --name repo1 --product prod3 --organization-id 5
                   --new-name rep1))
      end

      it 'by organization name' do
        expect_organization_search('org5', 5)

        ex = api_expects(:products, :index) do |p|
          p['name'] == 'prod3' && p['organization_id'] == 5
        end
        ex.returns(index_response([{'id' => 3}]))

        ex = api_expects(:repositories, :index) do |p|
          p['name'] == 'repo1' && p['product_id'] == 3
        end
        ex.returns(index_response([{'id' => 1}]))

        api_expects(:repositories, :update) do |p|
          p['id'] == 1 && p['name'] == 'rep1'
        end

        run_cmd(%w(repository update --name repo1 --product prod3 --organization org5
                   --new-name rep1))
      end

      it 'by organization label' do
        expect_organization_search('org5', 5, field: 'label')

        ex = api_expects(:products, :index) do |p|
          p['name'] == 'prod3' && p['organization_id'] == 5
        end
        ex.returns(index_response([{'id' => 3}]))

        ex = api_expects(:repositories, :index) do |p|
          p['name'] == 'repo1' && p['product_id'] == 3
        end
        ex.returns(index_response([{'id' => 1}]))

        api_expects(:repositories, :update) do |p|
          p['id'] == 1 && p['name'] == 'rep1'
        end

        run_cmd(%w(repository update --name repo1 --product prod3 --organization-label org5
                   --new-name rep1))
      end

      it 'update docker tag' do
        repo_id = 3
        upload_id = "1234"
        upload_response = {
          "upload_id" => upload_id,
          "_href" => "/pulp/api/v2/content/uploads/#{upload_id}"
        }

        ex = api_expects(:content_uploads, :create, "Create upload for content")
             .with_params(:repository_id => repo_id)

        ex.returns(upload_response)

        ex2 = api_expects(:repositories, :import_uploads, 'Take in an upload')
              .with_params(:id => repo_id,
                           :uploads => [{
                             :id => '1234',
                             :name => 'tag',
                             :digest => 'sha256:1234'
                           }],
                           :sync_capsule => true,
                           :publish_repository => true
                          )

        ex2.returns('output' => {'upload_results' => [{'type' => 'docker_tag',
                                                       'digest' => 'sha256:1234'}]})

        ex3 = api_expects(:content_uploads, :destroy, "Delete the upload")
              .with_params(:id => upload_id, :repository_id => repo_id)

        ex3.returns("")

        result = run_cmd(["repository", "update", "--id", repo_id,
                          "--docker-tag", "tag", "--docker-digest", "sha256:1234"])
        assert_equal(result.exit_code, 0)
      end

      it 'checks --docker-tag option' do
        result = run_cmd(%w(repository update --id 3 --docker-tag tag))
        assert_equal(result.err, "Could not update the repository:\n  " \
                                 "Error: --docker-digest required with --docker-tag\n  \n  " \
                                 "See: 'hammer repository update --help'.\n")
        assert_equal(result.exit_code, 64)
      end

      it 'checks --docker-digest option' do
        result = run_cmd(%w(repository update --id 3 --docker-digest sha256:1234))
        assert_equal(result.err, "Could not update the repository:\n  " \
                                 "Error: --docker-tag required with --docker-digest\n  \n  " \
                                 "See: 'hammer repository update --help'.\n")
        assert_equal(result.exit_code, 64)
      end
    end
  end
end
# rubocop:enable ModuleLength
