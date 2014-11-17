module HammerCLIKatello
  class HostCollectionPackageGroupCommand < HammerCLIKatello::Command
    command_name "package-group"
    desc _("Manipulate package-groups for a host collection")

    module PackageGroupContentType
      def self.included(base)
        base.option('--package-groups',
          'PACKAGE-GROUPS',
          _("comma-separated list of package-groups to install"),
          :required => true,
          :format => HammerCLI::Options::Normalizers::List.new,
          :attribute_name => :content)
      end

      def content_type
        'package_group'
      end
    end

    class InstallCommand < HammerCLIKatello::HostCollection::InstallContentBaseCommand
      include PackageGroupContentType
      desc _("Install package-groups on content hosts contained within a host collection")
      success_message _("Successfully scheduled installation of package-group(s)")
      failure_message _("Could not schedule installation of package-group(s)")
    end

    class UpdateCommand < HammerCLIKatello::HostCollection::UpdateContentBaseCommand
      include PackageGroupContentType
      desc _("Update package-groups on content hosts contained within a host collection")
      success_message _("Successfully scheduled update of package-groups(s)")
      failure_message _("Could not schedule update of package-group(s)")
    end

    class RemoveCommand < HammerCLIKatello::HostCollection::RemoveContentBaseCommand
      include PackageGroupContentType
      desc _("Remove package-groups on content hosts contained within a host collection")
      success_message _("Successfully scheduled removal of package-groups(s)")
      failure_message _("Could not schedule removal of package-group(s)")
    end

    autoload_subcommands
  end
end
