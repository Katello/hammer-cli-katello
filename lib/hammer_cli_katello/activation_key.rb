module HammerCLIKatello

  class ActivationKeyCommand < HammerCLI::AbstractCommand
    class ListCommand < HammerCLIKatello::ListCommand
      resource :activation_keys, :index

      output do
        field :id, _("ID")
        field :name, _("Name")
        field :format_consumed, _("Consumed")
      end

      def extend_data(data)
        data["format_consumed"] = _("%{consumed} of %{limit}") %
          {
            :consumed => data["usage_count"],
            :limit => data["usage_limit"] == -1 ? _("Unlimited") : data["usage_limit"]
          }
        data
      end

      apipie_options
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      resource :activation_keys, :show

      identifiers :id

      output do
        field :name, _("Name")
        field :id, _("ID")
        field :description, _("Description")
        from :environment do
          field :name, _("Lifecycle Environment")
        end
        from :content_view do
          field :name, _("Content View")
        end
      end

      apipie_options
    end

    autoload_subcommands
  end
end

HammerCLI::MainCommand.subcommand("activation-key", _("Manipulate activation keys."),
                                  HammerCLIKatello::ActivationKeyCommand)
