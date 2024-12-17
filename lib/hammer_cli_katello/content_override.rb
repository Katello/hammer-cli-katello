module HammerCLIKatello
  module ContentOverrideBase
    class ContentOverrideCommand < HammerCLIKatello::SingleResourceCommand
      def self.setup
        desc _("Override product content defaults")
        command_name "content-override"

        success_message _("Updated content override.")
        failure_message _("Could not update content override")

        option "--force", "FORCE", _("Force the override. Required for overrides other than 'enabled'"),
                :attribute_name => :option_force, default: false

        option "--content-label", "CONTENT_LABEL", _("Label of the content"),
               :attribute_name => :option_content_label, :required => true

        option "--override-name", "OVERRIDE_NAME", _("Override parameter key or name.\n" \
                                   "To enable or disable a repo select 'enabled'.\n" \
                                   "Default value: enabled"),
               :attribute_name => :option_override_name, :default => "enabled"

        option "--value", "VALUE", _("Override value. " \
                                     "Note for repo enablement you can use a boolean value"),
               :attribute_name => :option_value, :required => false

        option ["--remove"], :flag, _("Remove a content override")

        validate_options do
          any(:option_remove, :option_value).required

          if option(:option_remove).exist?
            option(:option_value).rejected
          elsif option(:option_value).exist?
            if !@option_values['option_override_name'].casecmp('enabled').zero? &&
               @option_values['option_force'] == false
              raise ArgumentError, _("You must use --force to set a value other than 'enabled'")
            end
            option(:option_remove).rejected
          end
        end
      end

      def request_params
        super.tap do |opts|
          opts.delete('content_override')
          override = { 'content_label' => option_content_label }
          override['value'] = option_value if option_value
          override['remove'] = true if option_remove?
          override['name'] = option_override_name
          opts['content_overrides'] = [override]
        end
      end
    end
  end
end
