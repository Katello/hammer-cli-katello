require 'hammer_cli'
require 'hammer_cli_foreman'
require 'hammer_cli_foreman/commands'

module HammerCLIKatello

  class SubscriptionCommand < HammerCLI::AbstractCommand
    class ListCommand < HammerCLIKatello::ListCommand
      resource :subscriptions, :index

      output do
        field :product_name, _("Name")
        field :contract_number, _("Contract")
        field :account_number, _("Account")
        field :support_level, _("Support")
        field :quantity, _("Quantity")
        field :consumed, _("Consumed")
        field :end_date, _("End Date")
        field :id, _("ID")
        field :product_name, _("Product")
        field :format_quantity, _("Quantity")
        field :consumed, _("Attached")
      end

      def extend_data(data)
        data["format_quantity"] = data["quantity"] == -1 ? _("Unlimited") : data["quantity"]
        data
      end

      apipie_options
    end

    class UploadCommand < HammerCLIForemanTasks::AsyncCommand
      resource :subscriptions, :upload
      command_name "upload"

      class BinaryFile < HammerCLI::Options::Normalizers::File
        def format(path)
          ::File.new(::File.expand_path(path), 'rb')
        end
      end

      def request_headers
        {:content_type => 'multipart/form-data', :multipart => true}
      end

      success_message _("Manifest is being uploaded in task %{id}s")
      failure_message _("Manifest upload failed")

      apipie_options :without => [:content]
      option "--file", "MANIFEST", "Subscription manifest file",
             :attribute_name => :option_content,
             :required => true, :format => BinaryFile.new
    end

    class DeleteManfiestCommand < HammerCLIForemanTasks::AsyncCommand
      resource :subscriptions, :delete_manifest
      command_name "delete_manifest"

      success_message _("Manifest is being deleted in task %{id}s")
      failure_message _("Manifest deletion failed")

      apipie_options
    end

    class RefreshManfiestCommand < HammerCLIForemanTasks::AsyncCommand
      resource :subscriptions, :refresh_manifest
      command_name "refresh_manifest"

      success_message _("Manifest is being refreshed in task %{id}s")
      failure_message _("Manifest refresh failed")

      apipie_options
    end

    autoload_subcommands
  end
end

HammerCLI::MainCommand.subcommand("subscription", _("Manipulate subscriptions."),
                                  HammerCLIKatello::SubscriptionCommand)
