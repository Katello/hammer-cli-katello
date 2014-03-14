module HammerCLIKatello

  class FilterRule < HammerCLI::Apipie::Command

    resource KatelloApi::Resources::ContentViewFilterRule
    command_name 'rule'
    desc 'View and manage filter rules'

    class ListCommand < HammerCLIKatello::ListCommand
      output do
        field :id, "Rule ID"
        field :content_view_filter_id, "Filter ID"

        field :name, "Name"
        field :version, "Version"
        field :min_version, "Minimum Version"
        field :max_version, "Maximum Version"
        field :start_date, "Start Date"
        field :end_date, "End Date"
      end

      apipie_options
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      output do
        field :id, "Rule ID"
        field :content_view_filter_id, "Filter ID"

        field :name, "Name", Fields::Field, :hide_blank => true
        field :version, "Version", Fields::Field, :hide_blank => true
        field :min_version, "Minimum Version", Fields::Field, :hide_blank => true
        field :max_version, "Maximum Version", Fields::Field, :hide_blank => true
        field :start_date, "Start Date", Fields::Field, :hide_blank => true
        field :end_date, "End Date", Fields::Field, :hide_blank => true
        field :types, "Types", Fields::List, :hide_blank => true
        field :created_at, "Created", Fields::Date
        field :updated_at, "Updated", Fields::Date
      end

      apipie_options
    end

    class CreateCommand < HammerCLIKatello::CreateCommand
      success_message "Filter rule created"
      failure_message "Could not create the filter rule"

      apipie_options
    end

    class UpdateCommand < HammerCLIKatello::UpdateCommand
      success_message "Filter rule updated"
      failure_message "Could not update the filter rule"

      apipie_options
    end

    class DeleteCommand < HammerCLIKatello::DeleteCommand
      success_message "Filter rule deleted"
      failure_message "Could not delete the filter rule"

      def request_params
        super.merge(method_options)
      end

      apipie_options
    end

    autoload_subcommands
  end
end
