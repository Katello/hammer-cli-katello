require 'hammer_cli_katello/filter_rule'

module HammerCLIKatello

  class Filter < HammerCLI::Apipie::Command

    resource KatelloApi::Resources::Filter
    command_name 'filter'
    desc 'View and manage filters'

    class ListCommand < HammerCLIKatello::ListCommand
      output do
        field :id, "Filter ID"
        field :name, "Name"
        field :type, "Type"
        field :inclusion, "Inclusion"
      end

      apipie_options
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      output do
        field :id, "Filter ID"
        field :name, "Name"
        field :type, "Type"
        field :inclusion, "Inclusion"

        collection :repositories, "Repositories" do
          field :id, "ID"
          field :name, "Name"
          field :label, "Label"
        end

        collection :rules, "Rules" do
          field :id, "ID"
          field :name, "Name"
          field :version, "Version"
          field :min_version, "Minimum Version"
          field :max_version, "Maximum Version"
          field :start_date, "Start Date"
          field :end_date, "End Date"
          field :created_at, "Created"
          field :updated_at, "Updated"
        end
      end

      apipie_options :without => [:content_view_id]
    end

    class CreateCommand < HammerCLIKatello::CreateCommand
      success_message "Filter created"
      failure_message "Could not create the filter"

      apipie_options
    end

    class UpdateCommand < HammerCLIKatello::UpdateCommand
      success_message "Filter updated"
      failure_message "Could not update the filter"

      apipie_options :without => [:content_view_id]
    end

    class DeleteCommand < HammerCLIKatello::DeleteCommand
      success_message "Filter deleted"
      failure_message "Could not delete the filter"

      apipie_options :without => [:content_view_id]
    end

    include HammerCLIKatello::AssociatingCommands::Repository

    autoload_subcommands

    subcommand 'rule',
               HammerCLIKatello::FilterRule.desc,
               HammerCLIKatello::FilterRule

  end
end
