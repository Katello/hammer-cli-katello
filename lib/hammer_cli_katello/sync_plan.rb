module HammerCLIKatello
  class SyncPlan < HammerCLIKatello::Command
    resource :sync_plans

    class ListCommand < HammerCLIKatello::ListCommand
      output do
        field :id, _("ID")
        field :name, _("Name")
        field :sync_date, _("Start Date"), Fields::Date
        field :interval, _("Interval")
        field :enabled, _("Enabled"), Fields::Boolean
      end

      build_options
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      output ListCommand.output_definition do
        field :description, _("Description")
        field :created_at, _("Created at"), Fields::Date
        field :updated_at, _("Updated at"), Fields::Date

        collection :products, _("Products") do
          field :id, _("ID")
          field :name, _("Name")
        end
      end

      build_options
    end

    class CreateCommand < HammerCLIKatello::CreateCommand
      option "--interval", "INTERVAL", _("how often synchronization should run"),
             :format => HammerCLI::Options::Normalizers::Enum.new(
               %w(hourly daily weekly)
             )

      option "--sync-date", "SYNC_DATE",
             _("Start date and time for the sync plan." \
               "Time is optional, if kept blank current system time will be considered"),
             :format => HammerCLI::Options::Normalizers::DateTime.new

      success_message _("Sync plan created")
      failure_message _("Could not create the sync plan")

      build_options :without => [:interval, :sync_date]
    end

    class UpdateCommand < HammerCLIKatello::UpdateCommand
      option "--interval", "INTERVAL", _("how often synchronization should run"),
             :format => HammerCLI::Options::Normalizers::Enum.new(
               %w(hourly daily weekly)
             )
      option "--sync-date", "SYNC_DATE", _("start date and time of the synchronization"),
             :format => HammerCLI::Options::Normalizers::DateTime.new

      success_message _("Sync plan updated")
      failure_message _("Could not update the sync plan")

      build_options :without => [:interval, :sync_date]
    end

    class DeleteCommand < HammerCLIKatello::DeleteCommand
      success_message _("Sync plan destroyed")
      failure_message _("Could not destroy the sync plan")

      build_options
    end

    autoload_subcommands
  end
end
