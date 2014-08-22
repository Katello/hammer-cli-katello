module HammerCLIKatello

  class ContentViewPuppetModule < HammerCLIKatello::Command

    resource :content_view_puppet_modules
    command_name 'puppet-module'
    desc 'View and manage puppet modules'

    class ListCommand < HammerCLIKatello::ListCommand
      output do
        field :uuid, _("ID")
        field :name, _("Name")
        field :author, _("Author")
        field :version, _("Version")
      end

      def extend_data(mod)
        if mod['uuid']
          mod['version'] = mod['computed_version']
        else
          mod['version'] = _("Latest(Currently %s)") % mod['computed_version']
        end
        mod
      end

      build_options
    end

    class CreateCommand < HammerCLIKatello::CreateCommand
      command_name "add"

      option "--id", "ID", _("id of the puppet module to associate")

      def request_params
        super.tap { |params| params['uuid'] = params.delete('id') if params['id'] }
      end

      success_message _("Puppet module added to content view")
      failure_message _("Could not add the puppet module")

      build_options :without => :uuid
    end

    class DeleteCommand < HammerCLIKatello::DeleteCommand
      command_name "remove"

      success_message _("Puppet module removed from content view")
      failure_message _("Couldn't remove puppet module from the content view")

      def resolve_puppet_module_id_from_uuid(options)
        uuid = options.delete HammerCLI.option_accessor_name("id")
        options[HammerCLI.option_accessor_name("uuid")] = uuid
        resolver.content_view_puppet_module_id(options)
      end

      def all_options
        if super['option_id']
          super.merge(HammerCLI.option_accessor_name("id") =>
                      resolve_puppet_module_id_from_uuid(super))
        else
          super
        end
      end

      build_options :without => :uuid
    end

    autoload_subcommands
  end
end
