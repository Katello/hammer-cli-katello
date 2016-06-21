require_relative '../../test_helper'
require 'hammer_cli_katello/associating_commands'

module HammerCLIKatello
  module AssociatingCommands
    module HostCollection
      describe AddHostCollectionCommand do
        let(:api) { mock('api') }
        let(:command) { AddHostCollectionCommand.new api }

        before(:each) do
          command.class.superclass.any_instance.stubs(:all_options).returns({})
          command.class.superclass.any_instance.stubs(:request_params)
          command.stubs(:option_organization_id).returns(1)
        end

        it 'sets host-collection-organization-id to organization-id if not present' do
          command.request_params
          command.all_options['option_host_collection_organization_id'].must_equal(1)
        end
      end
    end
  end
end
