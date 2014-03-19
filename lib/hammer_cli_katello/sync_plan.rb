module HammerCLIKatello
  class SyncPlan < HammerCLIForeman::Command
    resource :sync_plans

    class ListCommand < HammerCLIForeman::ListCommand

      output do
        field :id, _("ID")
        field :name, _("Name")
        field :sync_date, _("Start Date"), Fields::Date
        field :interval, _("Interval")
      end

      apipie_options
    end

    class InfoCommand < HammerCLIForeman::InfoCommand
      identifiers :id

      output ListCommand.output_definition do
        field :created_at, _("Created at"), Fields::Date
        field :updated_at, _("Updated at"), Fields::Date
      end

      apipie_options
    end

    class CreateCommand < HammerCLIForeman::CreateCommand

      option "--interval", "INTERVAL", _("how often synchronization should run"),
             :default => 'none',
             :format => HammerCLI::Options::Normalizers::Enum.new(
                %w('none', 'hourly', 'daily', 'weekly')
              )
      option "--sync-date", "SYNC_DATE", _("start date and time of the synchronization"),
             :format => HammerCLI::Options::Normalizers::DateTime.new, :required => true

      success_message _("Sync plan created")
      failure_message _("Could not create the sync plan")

      apipie_options :without => [:interval, :sync_date]
    end

    class UpdateCommand < HammerCLIForeman::UpdateCommand
      identifiers :id

      option "--interval", "INTERVAL", _("how often synchronization should run"),
             :format => HammerCLI::Options::Normalizers::Enum.new(
                %('none', 'hourly', 'daily', 'weekly')
              )
      option "--sync-date", "SYNC_DATE", _("start date and time of the synchronization"),
             :format => HammerCLI::Options::Normalizers::DateTime.new

      success_message _("Sync plan updated")
      failure_message _("Could not update the sync plan")

      apipie_options :without => [:interval, :sync_date]
    end

    class DeleteCommand < HammerCLIForeman::DeleteCommand
      identifiers :id

      success_message _("Sync plan destroyed")
      failure_message _("Could not destroy the sync plan")

      apipie_options
    end

    autoload_subcommands
  end
end

HammerCLI::MainCommand.subcommand 'sync-plan', _("Manipulate sync plans"),
                                  HammerCLIKatello::SyncPlan
