module HammerCLIKatello

  class FilterRule < HammerCLI::Apipie::Command

    resource KatelloApi::Resources::ContentViewFilterRule
    command_name 'rule'
    desc 'View and manage filter rules'

    class ListCommand < HammerCLIKatello::ListCommand
      output do
        field :id, _("Rule ID")
        field :content_view_filter_id, _("Filter ID")

        field :name, _("Name")
        field :version, _("Version")
        field :min_version, _("Minimum Version")
        field :max_version, _("Maximum Version")
        field :errata_id, _("Errata ID")
        field :start_date, _("Start Date")
        field :end_date, _("End Date")
      end

      apipie_options
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      output do
        field :id, _("Rule ID")
        field :content_view_filter_id, _("Filter ID")

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

      apipie_options
    end

    class CreateCommand < HammerCLIKatello::CreateCommand
      success_message _("Filter rule created")
      failure_message _("Could not create the filter rule")

      apipie_options
    end

    class UpdateCommand < HammerCLIKatello::UpdateCommand
      success_message _("Filter rule updated")
      failure_message _("Could not update the filter rule")

      apipie_options
    end

    class DeleteCommand < HammerCLIKatello::DeleteCommand
      success_message _("Filter rule deleted")
      failure_message _("Could not delete the filter rule")

      def request_params
        super.merge(method_options)
      end

      apipie_options
    end

    autoload_subcommands
  end
end
