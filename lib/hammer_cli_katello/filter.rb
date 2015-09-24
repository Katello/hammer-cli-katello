require 'hammer_cli_katello/filter_rule'

module HammerCLIKatello

  class Filter < HammerCLIKatello::Command

    resource :content_view_filters
    command_name 'filter'
    desc 'View and manage filters'

    class ListCommand < HammerCLIKatello::ListCommand
      output do
        field :id, _("Filter ID")
        field :name, _("Name")
        field :type, _("Type")
        field :inclusion, _("Inclusion")
      end

      build_options
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      output do
        field :id, _("Filter ID")
        field :name, _("Name")
        field :type, _("Type")
        field :inclusion, _("Inclusion")
        field :description, _("Description")

        collection :repositories, _("Repositories") do
          field :id, _("ID")
          field :name, _("Name")
          field :label, _("Label")
        end

        collection :rules, _("Rules") do
          field :id, _("ID")
          field :name, _("Name"), Fields::Field, :hide_blank => true
          field :version, _("Version"), Fields::Field, :hide_blank => true
          field :min_version, _("Minimum Version"), Fields::Field, :hide_blank => true
          field :max_version, _("Maximum Version"), Fields::Field, :hide_blank => true
          field :errata_id, _("Errata ID"), Fields::Field, :hide_blank => true
          field :start_date, _("Start Date"), Fields::Field, :hide_blank => true
          field :end_date, _("End Date"), Fields::Field, :hide_blank => true
          field :types, _("Types"), Fields::List, :hide_blank => true
          field :created_at, _("Created"), Fields::Date
          field :updated_at, _("Updated"), Fields::Date
        end
      end

      build_options :without => [:content_view_id]
    end

    class CreateCommand < HammerCLIKatello::CreateCommand
      success_message _("Filter created")
      failure_message _("Could not create the filter")

      build_options
    end

    class UpdateCommand < HammerCLIKatello::UpdateCommand
      success_message _("Filter updated")
      failure_message _("Could not update the filter")

      build_options :without => [:content_view_id]
    end

    class DeleteCommand < HammerCLIKatello::DeleteCommand
      success_message _("Filter deleted")
      failure_message _("Could not delete the filter")

      build_options :without => [:content_view_id]
    end

    HammerCLIKatello::AssociatingCommands::Repository.extend_command(self)

    autoload_subcommands

    subcommand HammerCLIKatello::FilterRule.command_name,
               HammerCLIKatello::FilterRule.desc,
               HammerCLIKatello::FilterRule

  end
end
