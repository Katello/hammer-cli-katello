require_relative '../test_helper.rb'
require_relative '../organization/organization_helpers'
require_relative '../content_view/content_view_helpers'
require_relative '../repository/repository_helpers'
require_relative '../product/product_helpers'
require 'hammer_cli_katello/content_units'

module HammerCLIKatello
  describe ContentUnitsCommand::InfoCommand do
    include ContentViewHelpers
    include RepositoryHelpers
    include ProductHelpers
    include OrganizationHelpers

    it 'allows minimal options' do
      api_expects(:generic_content_units, :show)
        .with_params('content_type' => 'python_package', 'id' => '1492')

      run_cmd(%w(content-units info --content-type python_package --id 1492))
    end

    it 'requires content_type param' do
      api_expects_no_call

      r = run_cmd(%w(content-units info --id 1492))
      assert(r.err.include?("Missing arguments for '--content-type'"), "Invalid error message")
    end
  end
end
