module HammerCLIKatello
  class ContentHostContentOverrideCommand < HammerCLIKatello::Command
    command_name "content-override"
    desc _("Manipulate content-overrides for a content host")

    class ListCommand < HammerCLIKatello::ContentHostCommand::GetContentOverrideCommand
      desc _("List content overrides")
      output do
        from :content do
          field :id, _("ID")
          field :name, _("Name")
          field :label, _("Label")
        end

        field :format_enabled, _("Enabled?")
      end

      def extend_data(data)
        if data['enabled_override'] == "default"
          data['format_enabled'] = data['enabled'] ? _("Yes") : _("No")
          data['format_enabled'] << " (Default)"
        else
          data['format_enabled'] = _("Override to ")
          data['format_enabled'] << (data['enabled_override'] == "0" ? _("No") : _("Yes"))
        end
        data
      end

      build_options
    end

    class UpdateCommand < HammerCLIKatello::ContentHostCommand::SetContentOverrideCommand
      desc _("Override product content defaults")

      success_message _("Updated content override")
      failure_message _("Could not update content override")

      build_options
    end

    autoload_subcommands
  end
end
