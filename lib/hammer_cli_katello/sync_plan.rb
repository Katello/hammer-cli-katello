module HammerCLIKatello
  class SyncPlan < HammerCLI::Apipie::Command
    resource KatelloApi::Resources::SyncPlan

    class ListCommand < HammerCLIForeman::ListCommand

      output do
        field :id, "ID"
        field :name, "Name"
        field :sync_date, "Start Date", Fields::Date
        field :interval, "Interval"
      end

      apipie_options
    end

    class InfoCommand < HammerCLIForeman::InfoCommand
      identifiers :id

      output ListCommand.output_definition do
        field :created_at, "Created at", Fields::Date
        field :updated_at, "Updated at", Fields::Date
      end

      apipie_options
    end

    class CreateCommand < HammerCLIForeman::CreateCommand

      option "--interval", "INTERVAL", "how often synchronization should run",
             :default => 'none',
             :format => HammerCLI::Options::Normalizers::Enum.new(
                %w('none', 'hourly', 'daily', 'weekly')
              )
      option "--sync-date", "SYNC_DATE", "start date and time of the synchronization",
             :format => HammerCLI::Options::Normalizers::DateTime.new, :required => true

      success_message "Sync plan created"
      failure_message "Could not create the sync plan"

      apipie_options :without => [:interval, :sync_date]
    end

    class UpdateCommand < HammerCLIForeman::UpdateCommand
      identifiers :id

      option "--interval", "INTERVAL", "how often synchronization should run",
             :format => HammerCLI::Options::Normalizers::Enum.new(
                %('none', 'hourly', 'daily', 'weekly')
              )
      option "--sync-date", "SYNC_DATE", "start date and time of the synchronization",
             :format => HammerCLI::Options::Normalizers::DateTime.new

      success_message "Sync plan updated"
      failure_message "Could not update the sync plan"

      apipie_options :without => [:interval, :sync_date]
    end

    class DeleteCommand < HammerCLIForeman::DeleteCommand
      identifiers :id

      success_message "Sync plan destroyed"
      failure_message "Could not destroy the sync plan"

      apipie_options
    end

    autoload_subcommands
  end
end

HammerCLI::MainCommand.subcommand 'sync_plan', "Manipulate sync plans",
                                  HammerCLIKatello::SyncPlan
