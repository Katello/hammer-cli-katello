module HammerCLIKatello

  class ActivationKeyCommand < HammerCLI::AbstractCommand
    class ListCommand < HammerCLIKatello::ListCommand
      resource KatelloApi::Resources::ActivationKey, 'index'

      output do
        field :id, "ID"
        field :name, "Name"
        field :format_consumed, "Consumed"
      end

      def extend_data(data)
        data["format_consumed"] = "%{consumed} of %{limit}" %
          {
            :consumed => data["usage_count"],
            :limit => data["usage_limit"] == -1 ? "Unlimited" : data["usage_limit"]
          }
        data
      end

      apipie_options
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      resource KatelloApi::Resources::ActivationKey, :show

      identifiers :id

      output do
        field :name, "Name"
        field :id, "ID"
        field :description, "Description"
        from :environment do
          field :name, "Lifecycle Environment"
        end
        from :content_view do
          field :name, "Content View"
        end
      end

      apipie_options
    end

    autoload_subcommands
  end
end

HammerCLI::MainCommand.subcommand("activation-key", "Manipulate activation keys.",
                                  HammerCLIKatello::ActivationKeyCommand)
