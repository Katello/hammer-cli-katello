module HammerCLIKatello
  module ProductContentBase
    class ProductContentCommand < HammerCLIKatello::ListCommand
      def self.setup
        desc _("List associated products")
        command_name "product-content"

        output do
          from :content do
            field :id, _("ID")
            field :name, _("Name")
            field :type, _("Type")
            field :contentUrl, _("URL")
            field :gpgUrl, _("GPG Key")
            field :label, _("Label")
          end
          field :enabled, _("Enabled?"), Fields::Boolean
          field :override_description, _("Override")
        end
        build_options
      end

      def extend_data(mod)
        formatted_overrides = mod["overrides"].map do |override|
          value = override['value']
          if override['name'] == "enabled"
            value = override['value'] ? '1' : '0'
          end
          "#{override['name']}:#{value}"
        end
        mod["override_description"] = formatted_overrides.join(", ")
        mod
      end
    end
  end
end
