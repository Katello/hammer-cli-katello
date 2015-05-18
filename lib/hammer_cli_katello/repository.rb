module HammerCLIKatello

  class Repository < HammerCLIKatello::Command
    resource :repositories

    class ListCommand < HammerCLIKatello::ListCommand
      output do
        field :id, _("Id")
        field :name, _("Name")
        from :product do
          field :name, _("Product")
        end
        field :content_type, _("Content Type")
        field :url, _("URL")
      end

      build_options
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      include RepositoryScopedToProduct

      output do
        field :id, _("ID")
        field :name, _("Name")
        field :label, _("Label")
        from :organization do
          field :name, _("Organization")
        end
        field :_redhat_repo, _("Red Hat Repository")
        field :content_type, _("Content Type")
        field :checksum_type, _("Checksum Type"), Fields::Field, :hide_blank => true
        field :url, _("URL")
        field :_publish_via_http, _("Publish Via HTTP")
        field :full_path, _("Published At")
        field :docker_upstream_name, _("Upstream Repository Name"),
              Fields::Field, :hide_blank => true
        field :container_repository_name, _("Container Repository Name"),
              Fields::Field, :hide_blank => true

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
          field :docker_image_total, _("Docker Images"), Fields::Field, :hide_blank => true
          field :docker_tag_total, _("Docker Tags"), Fields::Field, :hide_blank => true
        end
        collection :ostree_branches, _("RPM OS Tree Branches"),
                   :numbered => false, :hide_blank => true do
          custom_field Fields::Field
        end
      end

      def extend_data(data)
        data["_redhat_repo"] = data["product_type"] == "redhat" ? _("yes") : _("no")
        data["_publish_via_http"] = data["unprotected"] ? _("yes") : _("no")
        data["_sync_state"] = get_sync_status(data["sync_state"])
        if data["content_type"] == "yum" && data["gpg_key"]
          data["gpg_key_name"] = data["gpg_key"]["name"]
        end

        setup_content_counts(data) if data["content_counts"]
        data
      end

      def setup_content_counts(data)
        content_counts = data["content_counts"]
        case data["content_type"]
        when "yum"
          data["package_total"]  =  content_counts["rpm"]
          data["package_group_total"]  =  content_counts["package_group"]
          data["errata_total"]  =  content_counts["erratum"]
        when "docker"
          data["docker_image_total"] = content_counts["docker_image"]
          data["docker_tag_total"] = content_counts["docker_tag"]
        when "puppet"
          data["puppet_total"] = content_counts["puppet_module"]
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

      build_options do |o|
        o.expand.including(:products)
      end
    end

    class SyncCommand < HammerCLIKatello::SingleResourceCommand
      include HammerCLIForemanTasks::Async
      include RepositoryScopedToProduct

      action :sync
      command_name "synchronize"

      success_message _("Repository is being synchronized in task %{id}")
      failure_message _("Could not synchronize the repository")

      build_options do |o|
        o.expand.including(:products)
      end
    end

    class CreateCommand < HammerCLIKatello::CreateCommand
      success_message _("Repository created")
      failure_message _("Could not create the repository")

      option "--publish-via-http", "ENABLE", _("Publish Via HTTP"),
             :attribute_name => :option_unprotected,
             :format => HammerCLI::Options::Normalizers::Bool.new

      build_options :without => [:unprotected]
    end

    class UpdateCommand < HammerCLIKatello::UpdateCommand
      include RepositoryScopedToProduct

      success_message _("Repository updated")
      failure_message _("Could not update the repository")

      build_options(:without => [:unprotected]) do |o|
        o.expand.including(:products)
      end
      option "--publish-via-http", "ENABLE", _("Publish Via HTTP"),
             :attribute_name => :option_unprotected,
             :format => HammerCLI::Options::Normalizers::Bool.new
    end

    class DeleteCommand < HammerCLIKatello::DeleteCommand
      include RepositoryScopedToProduct

      success_message _("Repository deleted")
      failure_message _("Could not delete the Repository")

      build_options do |o|
        o.expand.including(:products)
      end
    end

    class UploadContentCommand < HammerCLIKatello::InfoCommand
      include RepositoryScopedToProduct

      resource :repositories, :upload_content
      command_name "upload-content"
      CONTENT_CHUNK_SIZE = 4_000_000 # bytes

      class BinaryPath < HammerCLI::Options::Normalizers::File
        def format(path)
          fullpath = ::File.expand_path(path)

          if File.directory?(fullpath)
            Dir["#{fullpath}/*"].map { |file| ::File.new(file, 'rb') }
          else
            [::File.new(fullpath, 'rb')]
          end
        end
      end

      def request_headers
        {:content_type => 'multipart/form-data', :multipart => true}
      end

      def execute
        @failure = false
        option_content.each { |file| upload_file(file) }

        @failure ? HammerCLI::EX_DATAERR : HammerCLI::EX_OK
      end

      def content_upload_resource
        ::HammerCLIForeman.foreman_resource(:content_uploads)
      end

      success_message _("Repository content uploaded")
      failure_message _("Could not upload the content")

      build_options(:without => [:content]) do |o|
        o.expand.including(:products)
      end
      option "--path", "PATH", _("Upload file or directory of files as content for a repository"),
             :attribute_name => :option_content,
             :required => true, :format => BinaryPath.new

      private

      def upload_file(file)
        upload_id = create_content_upload
        repo_id = get_identifier
        filename = File.basename(file.path)

        offset = 0
        while (content = file.read(CONTENT_CHUNK_SIZE))
          params = {:offset => offset,
                    :id => upload_id,
                    :content => content,
                    :repository_id => repo_id
          }

          content_upload_resource.call(:update, params, request_headers)
          offset += CONTENT_CHUNK_SIZE
        end

        import_upload_ids([upload_id])
        print_message _("Successfully uploaded file '%s'.") % filename
      rescue
        @failure = true
        print_message _("Failed to upload file '%s' to repository. Please check "\
                        "the file and try again.") % filename
      ensure
        content_upload_resource.call(:destroy, :repository_id => get_identifier, :id => upload_id)
      end

      def create_content_upload
        response = content_upload_resource.call(:create, :repository_id => get_identifier)

        response["upload_id"]
      end

      def import_upload_ids(ids)
        params = {:id => get_identifier,
                  :upload_ids => ids
        }
        resource.call(:import_uploads, params)
      end
    end

    class RemoveContentCommand < HammerCLIKatello::SingleResourceCommand
      include RepositoryScopedToProduct

      resource :repositories, :remove_content
      command_name "remove-content"

      option ["--content-ids"], "CONTENT_IDS",
        _("Comma separated list of package/puppet module/docker image ids"),
        :format => HammerCLI::Options::Normalizers::List.new, :required => true

      def request_params
        super.tap do |opts|
          opts[:uuids] = option_content_ids
        end
      end

      success_message _("Repository content removed")
      failure_message _("Could not remove content")

      build_options :without => ["uuids"]
    end

    autoload_subcommands
  end
end
