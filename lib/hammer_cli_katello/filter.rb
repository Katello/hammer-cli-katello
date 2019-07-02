require 'hammer_cli_katello/filter_rule'

module HammerCLIKatello
  class Filter < HammerCLIKatello::Command
    resource :content_view_filters
    command_name 'filter'
    desc 'View and manage filters'

    class ListCommand < HammerCLIKatello::ListCommand
      include OrganizationOptions
      extend IdNameOptionsValidator

      output do
        field :id, _("Filter ID")
        field :name, _("Name")
        field :description, _("Description")
        field :type, _("Type")
        field :inclusion, _("Inclusion")
      end

      build_options
      validate_id_or_name_with_parent :content_view
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      include OrganizationOptions
      extend IdNameOptionsValidator

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
      validate_id_or_name_with_parent parent: :content_view
      validate_id_or_name_with_parent :content_view, required: false
    end

    class CreateCommand < HammerCLIKatello::CreateCommand
      include OrganizationOptions

      success_message _("Filter created.")
      failure_message _("Could not create the filter")

      validate_options :before, 'IdResolution' do
        organization_options = [:option_organization_id, :option_organization_name, \
                                :option_organization_label]
        product_options = [:option_product_id, :option_product_name]

        if option(:option_product_name).exist? || option(:option_content_view_name).exist?
          any(*organization_options).required
        end

        if option(:option_repository_names).exist?
          any(*product_options).required
        end
      end

      build_options do |o|
        o.expand.including(:products)
      end
    end

    class UpdateCommand < HammerCLIKatello::UpdateCommand
      include OrganizationOptions
      extend IdNameOptionsValidator

      success_message _("Filter updated.")
      failure_message _("Could not update the filter")

      build_options :without => [:content_view_id]
      validate_id_or_name_with_parent parent: :content_view
      validate_id_or_name_with_parent :content_view, required: false
    end

    class DeleteCommand < HammerCLIKatello::DeleteCommand
      include OrganizationOptions
      extend IdNameOptionsValidator

      success_message _("Filter deleted.")
      failure_message _("Could not delete the filter")

      build_options :without => [:content_view_id]
      validate_id_or_name_with_parent parent: :content_view
      validate_id_or_name_with_parent :content_view, required: false
    end

    HammerCLIKatello::AssociatingCommands::Repository.extend_command(self)

    autoload_subcommands

    subcommand HammerCLIKatello::FilterRule.command_name,
               HammerCLIKatello::FilterRule.desc,
               HammerCLIKatello::FilterRule
  end
end
