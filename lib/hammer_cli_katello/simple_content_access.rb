module HammerCLIKatello
  class SimpleContentAccess < HammerCLIKatello::Command
    resource :simple_content_access

    desc "Toggle simple content access mode across organization"

    module EligibleCheck
      include ApipieHelper
      def request_params
        super.tap do |opts|
          unless call(:eligible, :simple_content_access, opts)["simple_content_access_eligible"]
            raise _("This organization is not eligible for Simple Content Access")
          end
        end
      end
    end

    class StatusCommand < HammerCLIKatello::ListCommand
      resource :simple_content_access, :status
      command_name "status"
      output do
        field :simple_content_access, _('Simple Content Access'), Fields::Boolean
      end

      build_options
    end

    class EnableCommand < HammerCLIKatello::SingleResourceCommand
      include EligibleCheck
      include HammerCLIForemanTasks::Async
      resource :simple_content_access, :enable
      command_name "enable"

      success_message _("Simple Content Access Enabled.")
      failure_message _("Could not enable Simple Content Access for this organization")

      build_options
    end

    class DisableCommand < HammerCLIKatello::SingleResourceCommand
      include EligibleCheck
      include HammerCLIForemanTasks::Async
      resource :simple_content_access, :disable
      command_name "disable"

      success_message _("Simple Content Access Disabled.")
      failure_message _("Could not disable Simple Content Access for this organization")

      build_options

      def execute
        warn _("Simple Content Access will be required for all organizations in the next release.")
        super
      end
    end

    autoload_subcommands
  end
end
