module HammerCLIKatello
  class Repository < HammerCLIKatello::Command
    resource :repositories

    module AnsibleCollectionRequirementsHelper
      def self.included(base)
        base.option "--ansible-collection-requirements-file",
                    "REQUIREMENTS_FILE", _("Location of the ansible collections "\
                                         "requirements.yml file. "),
                    :attribute_name => :option_ansible_collection_requirements_file,
                    :required => false
      end

      def request_params
        super.tap do |opts|
          requirements_file = option_ansible_collection_requirements_file
          if requirements_file
            opts["ansible_collection_requirements"] = File.read(requirements_file)
          end
        end
      end
    end

    class ListCommand < HammerCLIKatello::ListCommand
      include LifecycleEnvironmentNameMapping

      output do
        field :id, _("Id")
        field :name, _("Name")
        from :product do
          field :name, _("Product")
        end
        field :content_type, _("Content Type")
        field :content_label, _("Content Label")
        field :url, _("Url")
      end

      content_type_msg = _("Limit the repository type to return." \
        " View available types with \"hammer repository types\"")
      option "--content-type", "CONTENT TYPE",
             content_type_msg,
             :attribute_name => :option_content_type

      with_content_msg = _("Limit the repository type to return." \
        " View available types with \"hammer repository types\"")
      option "--with-content", "WITH CONTENT",
             with_content_msg,
             :attribute_name => :option_with_content

      build_options

      extend_with(HammerCLIKatello::CommandExtensions::LifecycleEnvironment.new)
    end

    # rubocop:disable ClassLength
    class InfoCommand < HammerCLIKatello::InfoCommand
      extend RepositoryScopedToProduct

      validate_repo_name_requires_product_options

      output do
        field :id, _("Id")
        field :name, _("Name")
        field :label, _("Label")
        field :description, _("Description")
        from :organization do
          field :name, _("Organization")
        end
        field :_redhat_repo, _("Red Hat Repository")
        field :content_type, _("Content Type")
        field :content_label, _("Content Label")
        field :checksum_type, _("Checksum Type"), Fields::Field, :hide_blank => true
        field :_mirroring_policy, _("Mirroring Policy"), Fields::Field, :hide_blank => true
        field :url, _("Url")
        field :_publish_via_http, _("Publish Via HTTP")
        field :full_path, _("Published At")
        field :relative_path, _("Relative Path")
        field :download_policy, _("Download Policy"), Fields::Field, :hide_blank => true
        field :metadata_expire, _("Metadata Expiration"), Fields::Field, :hide_blank => true
        field :docker_upstream_name, _("Upstream Repository Name"),
              Fields::Field, :hide_blank => true
        field :docker_tags_whitelist, _("Container Image Tags Filter"),
              Fields::List, :hide_blank => true
        field :container_repository_name, _("Container Repository Name"),
              Fields::Field, :hide_blank => true
        field :ignorable_content, _("Ignorable Content Units"), Fields::List, :hide_blank => true

        label _("HTTP Proxy") do
          from :http_proxy do
            field :id, _("Id"), Fields::Field, :hide_blank => true
            field :name, _("Name"), Fields::Field, :hide_blank => true
            field :policy, _("HTTP Proxy Policy"), Fields::Field, :hide_blank => true
          end
        end

        label _("Product") do
          from :product do
            field :id, _("Id")
            field :name, _("Name")
          end
        end

        label _("GPG Key") do
          from :gpg_key do
            field :id, _("Id"), Fields::Field, :hide_blank => true
            field :name, _("Name"), Fields::Field, :hide_blank => true
          end
        end

        label _("Sync") do
          field :_sync_state, _("Status")
          field :last_sync_words, _("Last Sync Date"), Fields::Field, :hide_blank => true
        end

        field :created_at, _("Created"), Fields::Date
        field :updated_at, _("Updated"), Fields::Date

        label _("Content Counts") do
          from :content_counts do
            field :rpm, _('Packages'), Fields::Field,
              :hide_blank => true
            field :srpm, _('SRPMs'), Fields::Field,
              :hide_blank => true
            field :module_stream, _('Module Streams'), Fields::Field,
              :hide_blank => true
            field :package_group, _('Package Groups'), Fields::Field,
              :hide_blank => true
            field :erratum, _('Errata'), Fields::Field,
              :hide_blank => true
            field :deb, _('Debian Packages'), Fields::Field,
              :hide_blank => true
            field :docker_tag, _('Container Tags'), Fields::Field,
              :hide_blank => true
            field :docker_manifest, _('Container Manifests'), Fields::Field,
              :hide_blank => true
            field :docker_manifest_list, _('Container Manifest Lists'), Fields::Field,
              :hide_blank => true
            field :file, _('Files'), Fields::Field,
              :hide_blank => true
            field :ansible_collection, _('Ansible Collections'), Fields::Field,
              :hide_blank => true
            field :ostree_ref, _('OSTree Refs'), Fields::Field,
              :hide_blank => true
            field :python_package, _('Python Packages'), Fields::Field,
              :hide_blank => true
          end
        end
      end

      def extend_data(data)
        if data["content_type"] != "docker"
          data.delete("docker_tags_whitelist")
        end

        if data["content_type"] == "yum" && data["gpg_key"]
          data["gpg_key_name"] = data["gpg_key"]["name"]
        end

        setup_sync_state(data)
        setup_booleans(data)
        setup_mirroring_policy(data)
        setup_content_counts(data) if data["content_counts"]
        data
      end

      def setup_booleans(data)
        data["_redhat_repo"] = data.dig("product", "redhat") ? _("yes") : _("no")
        data["_publish_via_http"] = data["unprotected"] ? _("yes") : _("no")
      end

      def setup_mirroring_policy(data)
        policies = {
          'additive' => _("Additive"),
          'mirror_content_only' => _("Content Only"),
          'mirror_complete' => _("Complete Mirroring")
        }
        mirroring_policy = data["mirroring_policy"]
        data["_mirroring_policy"] = policies[mirroring_policy]
      end

      def setup_sync_state(data)
        if data['last_sync']
          data['_sync_state'] = get_sync_status(data["last_sync"]["result"])
          data['last_sync'] = data['last_sync_words']
        else
          data['_sync_state'] = _("Not Synced")
        end
      end

      def setup_content_counts(data)
        content_counts = data["content_counts"]
        case data["content_type"]
        when "yum"
          data["package_total"] = content_counts["rpm"]
          data["srpm_total"] = content_counts["srpm"]
          data["package_group_total"] = content_counts["package_group"]
          data["errata_total"] = content_counts["erratum"]
          data["module_stream_total"] = content_counts["module_stream"]
        when "docker"
          data["docker_manifest_list_total"] = content_counts["docker_manifest_list"]
          data["docker_manifest_total"] = content_counts["docker_manifest"]
          data["docker_tag_total"] = content_counts["docker_tag"]
        when "file"
          data["file_total"] = content_counts["file"]
        end
      end

      def get_sync_status(state)
        sync_states = {
          "failed" => _("Failed"), "success" => _("Success"), "finished" => _("Finished"),
          "error" => _("Error"), "running" => _("Running"), "waiting" => _("Waiting"),
          "canceled" => _("Canceled"), "not_synced" => _("Not Synced"), "warning" => _("Warning")
        }
        sync_states[state]
      end

      build_options do |o|
        o.expand.including(:products, :organizations)
      end
    end
    # rubocop:enable ClassLength

    class SyncCommand < HammerCLIKatello::SingleResourceCommand
      include HammerCLIForemanTasks::Async
      extend RepositoryScopedToProduct

      validate_repo_name_requires_product_options

      action :sync
      command_name "synchronize"

      success_message _("Repository is being synchronized in task %{id}.")
      failure_message _("Could not synchronize the repository")

      build_options do |o|
        o.expand.including(:products, :organizations)
      end
    end

    class CreateCommand < HammerCLIKatello::CreateCommand
      include AnsibleCollectionRequirementsHelper
      success_message _("Repository created.")
      failure_message _("Could not create the repository")

      option "--publish-via-http", "ENABLE", _("Publish Via HTTP"),
             :attribute_name => :option_unprotected,
             :format => HammerCLI::Options::Normalizers::Bool.new

      content_type_msg = _("Type of repository to create." \
        " View available types with \"hammer repository types\"")
      option "--content-type", "CONTENT TYPE",
             content_type_msg,
             :attribute_name => :option_content_type

      build_options :without => [:unprotected]
    end

    class UpdateCommand < HammerCLIKatello::UpdateCommand
      extend RepositoryScopedToProduct
      include AnsibleCollectionRequirementsHelper

      validate_repo_name_requires_product_options
      include OrganizationOptions

      success_message _("Repository updated.")
      failure_message _("Could not update the repository")

      validate_options :before, 'IdResolution' do
        organization_options = [:option_organization_id, :option_organization_name, \
                                :option_organization_label]

        if option(:option_product_name).exist?
          any(*organization_options).required
        end

        if option(:option_docker_tag).exist? != option(:option_docker_digest).exist?
          option(:option_docker_tag).rejected(
            :msg => _('--docker-digest required with --docker-tag'))
          option(:option_docker_digest).rejected(
            :msg => _('--docker-tag required with --docker-digest'))
        end
      end

      build_options(:without => [:unprotected]) do |o|
        o.expand.including(:products)
      end
      option "--publish-via-http", "ENABLE", _("Publish Via HTTP"),
             :attribute_name => :option_unprotected,
             :format => HammerCLI::Options::Normalizers::Bool.new
      option "--docker-tag", "TAG", _("Container Image tag")
      option "--docker-digest", "DIGEST", _("Container Image manifest digest")

      def execute
        @failure = false

        if option_docker_tag
          upload_tag(option_docker_tag, option_docker_digest)
        else
          super
        end

        @failure ? HammerCLI::EX_DATAERR : HammerCLI::EX_OK
      end

      def content_upload_resource
        ::HammerCLIForeman.foreman_resource(:content_uploads)
      end

      def upload_tag(tag, digest)
        upload_id = create_content_upload
        import_uploads([
          {
            id: upload_id,
            name: tag,
            digest: digest
          }
        ], last_file: true)
        print_message _("Repository updated")
      rescue => e
        @failure = true
        logger.error e
        output.print_error _("Failed to upload tag '%s' to repository.") % tag
      ensure
        content_upload_resource.call(:destroy, :repository_id => get_identifier, :id => upload_id)
      end

      def create_content_upload
        response = content_upload_resource.call(:create,
                                                :repository_id => get_identifier,
                                                :size => 0
                                               )

        response["upload_id"]
      end

      def import_uploads(uploads, opts = {})
        publish_repository = opts.fetch(:last_file, false)
        sync_capsule = opts.fetch(:last_file, false)
        params = {:id => get_identifier,
                  :uploads => uploads,
                  publish_repository: publish_repository,
                  sync_capsule: sync_capsule,
                  content_type: "docker_tag"
        }
        resource.call(:import_uploads, params)
      end
    end

    class DeleteCommand < HammerCLIKatello::DeleteCommand
      extend RepositoryScopedToProduct
      include OrganizationOptions

      validate_repo_name_requires_product_options
      success_message _("Repository deleted.")
      failure_message _("Could not delete the Repository")

      build_options do |o|
        o.expand.including(:products)
      end
    end

    class RepositoryTypesCommand < HammerCLIKatello::InfoCommand
      resource :repositories, :repository_types
      command_name "types"

      output do
        field :name, _("Name")
        collection :content_types, _('Content types') do
          field :label, _('Type')
          field :generic, _('Generic?')
          field :removable, _('Removable?')
          field :uploadable, _('Uploadable?')
          field :indexed, _('Indexed?')
        end
      end

      build_options
    end

    # rubocop:disable ClassLength
    class UploadContentCommand < HammerCLIKatello::InfoCommand
      extend RepositoryScopedToProduct
      include HammerCLIForemanTasks::Helper

      validate_repo_name_requires_product_options
      resource :repositories, :upload_content
      command_name "upload-content"
      CONTENT_CHUNK_SIZE = 2_500_000 # bytes to make sure it's lower than django's default 2621440

      content_type_msg = _("The type of content unit to upload (srpm, file, etc.)." \
        " View uploadable types with \"hammer repository types\"")
      option "--content-type", "CONTENT TYPE",
             content_type_msg,
             :attribute_name => :option_content_type

      class BinaryPath < HammerCLI::Options::Normalizers::File
        def format(path)
          fullpath = ::File.expand_path(path)

          if File.directory?(fullpath)
            Dir["#{fullpath}/*"]
          elsif File.exist?(fullpath)
            [fullpath]
          else
            Dir[fullpath]
          end
        end
      end

      def request_headers
        {:content_type => 'multipart/form-data'}
      end

      def execute
        @failure = false
        files = option_content.sort

        if files.length.zero?
          output.print_error _("Could not find any files matching PATH")
          return HammerCLI::EX_NOINPUT
        end

        files.each do |file_path|
          last_file = file_path == files.last
          File.open(file_path, 'rb') { |file| upload_file(file, last_file: last_file) }
        end

        @failure ? HammerCLI::EX_DATAERR : HammerCLI::EX_OK
      end

      def content_upload_resource
        ::HammerCLIForeman.foreman_resource(:content_uploads)
      end

      validate_options :before, 'IdResolution' do
        organization_options = [:option_organization_id, :option_organization_name,
                                :option_organization_label]
        product_options = [:option_product_id, :option_product_name]
        repository_options = [:option_id, :option_name]

        any(*repository_options).required

        if option(:option_name).exist?
          any(*product_options).required
        end

        if option(:option_id).exist?
          any(*product_options).rejected(
            msg: _("Cannot specify both product options and repository ID."))
        end

        if option(:option_product_name).exist?
          any(*organization_options).required
        end
      end

      success_message _("Repository content uploaded.")
      failure_message _("Could not upload the content")

      build_options(:without => [:content]) do |o|
        o.expand.including(:products, :organizations)
      end

      option "--async", :flag, _("Do not wait for the task.")

      option "--ostree-repository-name", "OSTREE REPOSITORY NAME",
        _("Name of OSTree repository in archive."),
        :attribute_name => :option_ostree_repository_name,
        :required => false

      option "--path", "PATH", _("Upload file, directory of files, or glob of files " \
                                 "as content for a repository.\n" \
                                 "Globs must be escaped by single or double quotes"),
             :attribute_name => :option_content,
             :required => true, :format => BinaryPath.new

      private

      def upload_file(file, opts = {})
        total_size = File.size(file)
        checksum = Digest::SHA256.hexdigest(File.read(file))
        content_type = options["option_content_type"] ? options["option_content_type"] : nil
        filename = File.basename(file.path)
        upload_create_response = create_content_upload(total_size, checksum, content_type)
        upload_id = upload_create_response["upload_id"] || "duplicate"
        content_unit_id = upload_create_response["content_unit_href"]
        unless content_unit_id
          repo_id = get_identifier
          update_content_upload(upload_id, repo_id, file)
        end
        opts[:ostree_repository_name] = options["option_ostree_repository_name"]
        opts[:filename] = filename
        results = import_uploads([
          {
            id: upload_id,
            content_unit_id: content_unit_id,
            name: filename,
            size: file.size,
            checksum: checksum
          }], opts)
        print_results(filename, results, options["option_async"])
      ensure
        if upload_id
          content_upload_resource.call(:destroy, :repository_id => get_identifier, :id => upload_id)
        end
      end

      def create_content_upload(size, checksum, content_type)
        params = {
          :repository_id => get_identifier,
          :size => size,
          :checksum => checksum,
          :content_type => content_type
        }
        response = content_upload_resource.call(:create, params)
        response
      end

      def update_content_upload(upload_id, repo_id, file)
        offset = 0

        while (content = file.read(CONTENT_CHUNK_SIZE))
          params = {
            :offset => offset,
            :id => upload_id,
            :content => content,
            :size => file.size,
            :repository_id => repo_id,
            :multipart => true
          }
          # To workaround rest-client bug with false negative warnings,
          # see https://github.com/rest-client/rest-client/pull/670 for more details
          silence_warnings do
            content_upload_resource.call(:update, params, request_headers)
          end
          offset += CONTENT_CHUNK_SIZE
        end
      end

      def import_uploads(uploads, opts = {})
        publish_repository = opts.fetch(:last_file, false)
        sync_capsule = opts.fetch(:last_file, false)
        params = {:id => get_identifier,
                  :uploads => uploads,
                  publish_repository: publish_repository,
                  sync_capsule: sync_capsule,
                  async: true
        }
        params[:content_type] = options["option_content_type"] if options["option_content_type"]
        if options["option_ostree_repository_name"]
          params[:ostree_repository_name] = options["option_ostree_repository_name"]
        end
        results = if options["option_async"]
                    resource.call(:import_uploads, params)
                  else
                    task_progress(resource.call(:import_uploads, params))
                  end
        results
      end

      def task_progress(task_or_id)
        super
        task_id = task_or_id.is_a?(Hash) ? task_or_id['id'] : task_or_id
        load_task(task_id)
      end

      # rubocop:disable CyclomaticComplexity
      # rubocop:disable PerceivedComplexity
      def print_results(name, results, async)
        if !%w(error warning).include?(results) && !async # task successful && no async flag used
          upload_results = results.dig('output', 'upload_results') || []

          if upload_results.empty?
            print_message _("Successfully uploaded file %s") % name
          else
            upload_results.each do |result|
              if result['type'] == 'docker_manifest'
                print_message(
                  _("Successfully uploaded manifest file '%{name}' with digest '%{digest}'") % {
                    :name => name, :digest => result['digest'] })
              else
                print_message _("Successfully uploaded file %s") % name
              end
            end
          end
        elsif results&.dig('id') && async # async flag used
          print_message _("Content is being uploaded in task #{results['id']}.")
        else
          print_message _("Could not upload the content.")
        end
      end
      # rubocop:enable CyclomaticComplexity
      # rubocop:enable PerceivedComplexity

      def silence_warnings
        original_verbose = $VERBOSE
        $VERBOSE = nil
        begin
          yield
        ensure
          $VERBOSE = original_verbose
        end
      end
    end

    class RemoveContentCommand < HammerCLIKatello::SingleResourceCommand
      extend RepositoryScopedToProduct
      include OrganizationOptions

      validate_repo_name_requires_product_options
      action :remove_content
      command_name "remove-content"
      desc _("Remove content from a repository")

      success_message _("Repository content removed.")
      failure_message _("Could not remove content")

      validate_options :before, 'IdResolution' do
        organization_options = [:option_organization_id, :option_organization_name, \
                                :option_organization_label]

        if option(:option_product_name).exist?
          any(*organization_options).required
        end
      end

      content_type_msg = _("The type of content unit to remove (srpm, docker_manifest, etc.)." \
        " View removable types with \"hammer repository types\"")
      option "--content-type", "CONTENT TYPE",
             content_type_msg,
             :attribute_name => :option_content_type

      build_options do |o|
        o.expand.including(:products)
      end
    end

    class RepublishCommand < HammerCLIKatello::SingleResourceCommand
      extend RepositoryScopedToProduct
      include HammerCLIForemanTasks::Async
      include OrganizationOptions

      validate_repo_name_requires_product_options
      action :republish
      command_name "republish"
      desc _("Forces a republish of the specified repository.")

      success_message _("Repository republished.")
      failure_message _("Could not republish the repository.")

      validate_options :before, 'IdResolution' do
        organization_options = [:option_organization_id, :option_organization_name, \
                                :option_organization_label]

        if option(:option_product_name).exist?
          any(*organization_options).required
        end
      end

      build_options do |o|
        o.expand.including(:products)
      end
    end

    class ReclaimSpaceCommand < HammerCLIKatello::SingleResourceCommand
      extend RepositoryScopedToProduct
      include HammerCLIForemanTasks::Async
      include OrganizationOptions
      validate_repo_name_requires_product_options
      action :reclaim_space
      command_name "reclaim-space"
      desc _("Reclaim space from an On Demand repository")

      success_message _("Repository space reclaimed.")
      failure_message _("Could not reclaim the repository")

      validate_options :before, 'IdResolution' do
        organization_options = [:option_organization_id, :option_organization_name, \
                                :option_organization_label]

        if option(:option_product_name).exist?
          any(*organization_options).required
        end
      end

      build_options do |o|
        o.expand.including(:products)
      end
    end
    # rubocop:enable ClassLength
    autoload_subcommands
  end
end
