require 'hammer_cli_foreman/organization'

module HammerCLIKatello
  class Organization < HammerCLIForeman::Organization
    class ListCommand < HammerCLIForeman::Organization::ListCommand
      include HammerCLIKatello::ResolverCommons
      resource :organizations, :index

      output do
        field :label, _("Label")
      end

      build_options
    end

    class InfoCommand < HammerCLIForeman::Organization::InfoCommand
      include HammerCLIKatello::ResolverCommons
      resource :organizations, :show

      output do
        field :label, _("Label")
        field :description, _("Description")
        field :simple_content_access_label, _("Simple Content Access")
        field :service_levels, _("Service Levels"), Fields::List
        from :cdn_configuration do
          label "CDN configuration", hide_blank: true do
            field :url, _("URL"), Fields::Field, hide_blank: true
            field :upstream_organization_label, _("Upstream Organization"),
                                               Fields::Field, hide_blank: true
            field :username, _("Username"), Fields::Field, hide_blank: true
            field :ssl_ca_credential_id, _("SSL CA Credential ID"), Fields::Field, hide_blank: true
          end
        end
      end

      def extend_data(data)
        data["simple_content_access_label"] = if data["simple_content_access"]
                                                _("Enabled")
                                              else
                                                _("Disabled")
                                              end
        data
      end

      build_options
    end

    class UpdateCommand < HammerCLIForeman::Organization::UpdateCommand
      include HammerCLIKatello::ResolverCommons
      resource :organizations, :update

      success_message _("Organization updated.")
      failure_message _("Could not update the organization")

      build_options do |o|
        o.expand(:all).except(:environments)
      end
    end

    class CreateCommand < HammerCLIForeman::Organization::CreateCommand
      include HammerCLIKatello::ResolverCommons
      resource :organizations, :create

      success_message _("Organization created.")
      failure_message _("Could not create the organization")

      build_options do |o|
        o.expand(:all).except(:environments)
      end
    end

    class DeleteCommand < HammerCLIForeman::Organization::DeleteCommand
      include HammerCLIKatello::ResolverCommons
      include HammerCLIForemanTasks::Async
      resource :organizations, :destroy

      success_message _("Organization deleted.")
      failure_message _("Could not delete the organization")

      build_options
    end

    class ConfigureCdnCommand < HammerCLIKatello::SingleResourceCommand
      include HammerCLIKatello::ResolverCommons
      resource :organizations, :cdn_configuration
      command_name "configure-cdn"
      success_message _("Updated CDN configuration.")
      failure_message _("Could not update CDN configuration.")

      build_options do |o|
        o.expand(:all).except(:organizations, :locations)
        o.without(:organization_id, :location_id)
      end
    end

    autoload_subcommands
  end
end
