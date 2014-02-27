require 'hammer_cli'
require 'katello_api'
require 'hammer_cli_foreman'
require 'hammer_cli_foreman/commands'

module HammerCLIKatello

  class SubscriptionCommand < HammerCLI::AbstractCommand
    class ListCommand < HammerCLIKatello::ListCommand
      resource KatelloApi::Resources::Subscription, 'index'

      output do
        field :product_name, "Name"
        field :contract_number, "Contract"
        field :account_number, "Account"
        field :support_level, "Support"
        field :quantity, "Quantity"
        field :consumed, "Consumed"
        field :end_date, "End Date"
        field :id, "ID"
        field :product_name, "Product"
        field :format_quantity, "Quantity"
        field :consumed, "Attached"
      end

      def extend_data(data)
        data["format_quantity"] = data["quantity"] == -1 ? "Unlimited" : data["quantity"]
        data
      end

      apipie_options
    end

    class UploadCommand < HammerCLIKatello::WriteCommand
      resource KatelloApi::Resources::Subscription, 'upload'
      command_name "upload"

      class BinaryFile < HammerCLI::Options::Normalizers::File
        def format(path)
          ::File.new(::File.expand_path(path), 'rb')
        end
      end

      def request_headers
        {:content_type => 'multipart/form-data', :multipart => true}
      end

      success_message "Manifest is being uploaded in task %{id}s"
      failure_message "Manifest upload failed"

      apipie_options :without => [:content]
      option "--file", "MANIFEST", "Subscription manifest file",
             :attribute_name => :option_content,
             :required => true, :format => BinaryFile.new
    end

    class DeleteManfiestCommand < HammerCLIKatello::WriteCommand
      resource KatelloApi::Resources::Subscription, 'delete_manifest'
      command_name "delete_manifest"

      success_message "Manifest is being deleted in task %{id}s"
      failure_message "Manifest deletion failed"

      apipie_options
    end

    class RefreshManfiestCommand < HammerCLIKatello::WriteCommand
      resource KatelloApi::Resources::Subscription, 'refresh_manifest'
      command_name "refresh_manifest"

      success_message "Manifest is being refreshed in task %{id}s"
      failure_message "Manifest refresh failed"

      apipie_options
    end

    autoload_subcommands
  end
end

HammerCLI::MainCommand.subcommand("subscription", "Manipulate subscriptions.",
                                  HammerCLIKatello::SubscriptionCommand)
