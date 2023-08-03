module HammerCLIKatello
  class HostCollectionPackageCommand < HammerCLIKatello::Command
    command_name "package"
    desc _("Manipulate packages for a host collection")

    module PackageContentType
      def self.included(base)
        base.option('--packages',
                    'PACKAGES',
                    _("comma-separated list of packages to install"),
                    :required => true,
                    :format => HammerCLI::Options::Normalizers::List.new,
                    :attribute_name => :content)
      end

      def content_type
        'package'
      end
    end

    class InstallCommand < HammerCLIKatello::HostCollection::InstallContentBaseCommand
      include PackageContentType
      desc _("Install packages on content hosts contained within a host collection")
      success_message _("Successfully scheduled installation of package(s).")
      failure_message _("Could not schedule installation of package(s)")

      def execute
        warn "This command uses katello agent and will be removed in favor of remote execution " \
          "in Katello 4.10."
        warn "The remote execution equivalent is `hammer job-invocation create --feature " \
          "katello_package_install`. Specify the host collection with the --search-query " \
          "parameter, e.g. `--search-query \"host_collection = MyCollection\"` or " \
          "`--search-query \"host_collection_id=6\"`."
        super
      end
    end

    class UpdateCommand < HammerCLIKatello::HostCollection::UpdateContentBaseCommand
      include PackageContentType
      desc _("Update packages on content hosts contained within a host collection")
      success_message _("Successfully scheduled update of package(s).")
      failure_message _("Could not schedule update of package(s)")

      def execute
        warn "This command uses katello agent and will be removed in favor of remote execution " \
          "in Katello 4.10."
        warn "The remote execution equivalent is `hammer job-invocation create --feature " \
          "katello_package_update`. Specify the host collection with the --search-query " \
          "parameter, e.g. `--search-query \"host_collection = MyCollection\"` or " \
          "`--search-query \"host_collection_id=6\"`."
        super
      end
    end

    class RemoveCommand < HammerCLIKatello::HostCollection::RemoveContentBaseCommand
      include PackageContentType
      desc _("Remove packages on content hosts contained within a host collection")
      success_message _("Successfully scheduled removal of package(s).")
      failure_message _("Could not schedule removal of package(s)")

      def execute
        warn "This command uses katello agent and will be removed in favor of remote execution " \
          "in Katello 4.10."
        warn "The remote execution equivalent is `hammer job-invocation create --feature " \
          "katello_package_remove`. Specify the host collection with the --search-query " \
          "parameter, e.g. `--search-query \"host_collection = MyCollection\"` or " \
          "`--search-query \"host_collection_id=6\"`."
        super
      end
    end

    autoload_subcommands
  end
end
