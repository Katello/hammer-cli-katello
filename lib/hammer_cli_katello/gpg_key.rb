module HammerCLIKatello

  class GpgKeyCommand < HammerCLI::AbstractCommand

    class ListCommand < HammerCLIKatello::ListCommand
      resource KatelloApi::Resources::GpgKey, :index

      output do
        field :id, "ID"
        field :name, "Name"
      end

      apipie_options
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      resource KatelloApi::Resources::GpgKey, :show
      output do
        field :id, "ID"
        field :name, "Name"
        from :organization do
          field :name, "Organization"
        end

        collection :repositories, "Repositories" do
          field :id, "ID"
          field :name, "Name"
          field :content_type, "Content Type"
          from :product do
            field :name, "Product"
          end
        end

        # TODO: Below!
        # Need a better way to say
        # Contents
        # <content>

        field "", "Content"
        field :content, nil
      end

      def request_params
        super.merge(method_options)
      end

      apipie_options
    end

    class CreateCommand < HammerCLIKatello::CreateCommand
      resource KatelloApi::Resources::GpgKey, :create
      success_message "GPG Key created"
      failure_message "Could not create GPG Key"
      apipie_options  :without => [:content]
      option "--key", "GPG_KEY_FILE", "GPG Key file",
             :attribute_name => :option_content,
             :required => true,
             :format => HammerCLI::Options::Normalizers::File.new
    end

    class UpdateCommand < HammerCLIKatello::UpdateCommand
      success_message "GPG Key updated"
      failure_message "Could not update GPG Key"
      resource KatelloApi::Resources::GpgKey, :update

      identifiers :id

      def request_params
        super.merge(method_options)
      end

      apipie_options :without => [:content]
      option "--key", "GPG_KEY_FILE", "GPG Key file",
             :attribute_name => :option_content,
             :format => HammerCLI::Options::Normalizers::File.new
    end

    class DeleteCommand < HammerCLIKatello::DeleteCommand
      success_message "GPG Key deleted"
      failure_message "Could not delete the GPG Key"
      resource KatelloApi::Resources::GpgKey, :destroy

      identifiers :id
      def request_params
        super.merge(method_options)
      end

      apipie_options
    end

    autoload_subcommands
  end

  HammerCLI::MainCommand.subcommand("gpg",
                                    "manipulate GPG Key actions on the server",
                                    HammerCLIKatello::GpgKeyCommand)
end
