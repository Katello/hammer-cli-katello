module HammerCLIKatello

  class Repository < HammerCLIKatello::Command
    resource :repositories

    class ListCommand < HammerCLIKatello::ListCommand
      output do
        field :id, _("Id")
        field :name, _("Name")
        field :content_type, _("Content Type")
      end

    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      output do
        field :id, _("ID")
        field :name, _("Name")
        field :label, _("Label")
        from :organization do
          field :name, _("Organization")
        end
        field :_redhat_repo, _("Red Hat Repository")
        field :content_type, _("Content Type")
        field :url, _("URL")
        field :_publish_via_http, _("Publish Via HTTP")
        field :full_path, _("Published At")

        label _("Product") do
          from :product do
            field :id, _("ID")
            field :name, _("Name")
          end
        end

        label _("GPG Key") do
          from :gpg_key do
            field :id, _("ID"), Fields::Field, :hide_blank => true
            field :name, _("Name"), Fields::Field, :hide_blank => true
          end
        end

        label _("Sync") do
          field :_sync_state, _("Status")
          field :last_sync, _("Last Sync Date"), Fields::Date, :hide_blank => true
        end

        field :created_at, _("Created"), Fields::Date
        field :updated_at, _("Updated"), Fields::Date

        label _("Content Counts") do
          field :package_total, _("Packages"), Fields::Field, :hide_blank => true
          field :package_group_total, _("Package Groups"), Fields::Field, :hide_blank => true
          field :errata_total, _("Errata"), Fields::Field, :hide_blank => true
          field :puppet_total, _("Puppet Modules"), Fields::Field, :hide_blank => true
        end
      end

      def retrieve_data
        super.tap do |data|
          data["_redhat_repo"] = data["product_type"] == "redhat" ? _("yes") : _("no")
          data["_publish_via_http"] = data["unprotected"] ? _("yes") : _("no")
          data["_sync_state"] = get_sync_status(data["sync_state"])
          setup_content_counts(data)
        end
      end

      def setup_content_counts(data)
        if data["content_type"] == "yum"
          if data["content_counts"]
            data["package_total"]  =  data["content_counts"]["rpm"]
            data["package_group_total"]  =  data["content_counts"]["package_group"]
            data["errata_total"]  =  data["content_counts"]["erratum"]
          end
          data["gpg_key_name"] = data["gpg_key"]["name"] if data["gpg_key"]
        else
          data["puppet_total"] = data["content_counts"]["puppet_module"] if data["content_counts"]
        end
      end

      # rubocop:disable MethodLength
      def get_sync_status(state)
        sync_states = {
          "failed" => _("Failed"),
          "success" => _("Success"),
          "finished" => _("Finished"),
          "error" => _("Error"),
          "running" => _("Running"),
          "waiting" => _("Waiting"),
          "canceled" => _("Canceled"),
          "not_synced" => _("Not Synced")
        }
        sync_states[state]
      end

      def request_params
        super.merge(method_options)
      end

      apipie_options
    end

    class SyncCommand < HammerCLIForemanTasks::AsyncCommand
      action :sync
      command_name "synchronize"

      success_message _("Repository is being synchronized in task %{id}s")
      failure_message _("Could not synchronize the repository")

      apipie_options
    end

    class CreateCommand < HammerCLIKatello::CreateCommand
      success_message _("Repository created")
      failure_message _("Could not create the repository")

      apipie_options :without => [:unprotected]
      option "--publish-via-http", "ENABLE", _("Publish Via HTTP"),
             :attribute_name => :option_unprotected,
             :format => HammerCLI::Options::Normalizers::Bool.new
    end

    class UpdateCommand < HammerCLIKatello::UpdateCommand
      success_message _("Repository updated")
      failure_message _("Could not update the repository")

      apipie_options :without => [:unprotected]
      option "--publish-via-http", "ENABLE", _("Publish Via HTTP"),
             :attribute_name => :option_unprotected,
             :format => HammerCLI::Options::Normalizers::Bool.new
    end

    class DeleteCommand < HammerCLIKatello::DeleteCommand
      success_message _("Repository deleted")
      failure_message _("Could not delete the Repository")

      apipie_options
    end

    autoload_subcommands
  end
end

HammerCLI::MainCommand.subcommand "repository", _("Manipulate repositories"),
                                  HammerCLIKatello::Repository
