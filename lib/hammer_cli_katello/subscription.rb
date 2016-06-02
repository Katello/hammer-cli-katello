require 'hammer_cli'
require 'hammer_cli_foreman'
require 'hammer_cli_foreman/commands'

module HammerCLIKatello
  class SubscriptionCommand < HammerCLI::AbstractCommand
    class ListCommand < HammerCLIKatello::ListCommand
      resource :subscriptions, :index

      output do
        field :id, _("ID")
        field :cp_id, _("UUID")
        field :product_name, _("Name")
        field :contract_number, _("Contract")
        field :account_number, _("Account")
        field :support_level, _("Support")
        field :quantity, _("Quantity")
        field :consumed, _("Consumed")
        field :end_date, _("End Date")
        field :format_quantity, _("Quantity")
        field :consumed, _("Attached")
      end

      def extend_data(data)
        data["format_quantity"] = data["quantity"] == -1 ? _("Unlimited") : data["quantity"]
        data
      end

      build_options
    end

    class UploadCommand < HammerCLIKatello::Command
      include HammerCLIForemanTasks::Async

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

      success_message _("Manifest is being uploaded in task %{id}")
      failure_message _("Manifest upload failed")

      build_options :without => [:content]
      option "--file", "MANIFEST", _("Subscription manifest file"),
             :attribute_name => :option_content,
             :required => true, :format => BinaryFile.new
    end

    class DeleteManifestCommand < HammerCLIKatello::Command
      include HammerCLIForemanTasks::Async

      resource :subscriptions, :delete_manifest
      command_name "delete-manifest"

      success_message _("Manifest is being deleted in task %{id}")
      failure_message _("Manifest deletion failed")

      build_options do |o|
        o.expand.including(:systems)
      end
    end

    class RefreshManifestCommand < HammerCLIKatello::Command
      include HammerCLIForemanTasks::Async

      resource :subscriptions, :refresh_manifest
      command_name "refresh-manifest"

      success_message _("Manifest is being refreshed in task %{id}")
      failure_message _("Manifest refresh failed")

      build_options
    end

    class ManifestHistoryCommand < HammerCLIKatello::ListCommand
      command_name "manifest-history"
      resource :subscriptions, :manifest_history

      output do
        field :status, _("Status")
        field :statusMessage, _("Status Message")
        field :created, _("Time"), Fields::Date
      end

      build_options
    end

    autoload_subcommands
  end
end
