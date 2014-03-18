module HammerCLIKatello

  class GpgKeyCommand < HammerCLI::AbstractCommand

    class ListCommand < HammerCLIKatello::ListCommand
      resource KatelloApi::Resources::GpgKey, :index

      output do
        field :id, _("ID")
        field :name, _("Name")
      end

      apipie_options
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      resource KatelloApi::Resources::GpgKey, :show
      output do
        field :id, _("ID")
        field :name, _("Name")
        from :organization do
          field :name, _("Organization")
        end

        collection :repositories, "Repositories" do
          field :id, _("ID")
          field :name, _("Name")
          field :content_type, _("Content Type")
          from :product do
            field :name, _("Product")
          end
        end

        # TODO: Below!
        # Need a better way to say
        # Contents
        # <content>

        field "", _("Content")
        field :content, nil
      end

      def request_params
        super.merge(method_options)
      end

      apipie_options
    end

    class CreateCommand < HammerCLIKatello::CreateCommand
      resource KatelloApi::Resources::GpgKey, :create
      success_message _("GPG Key created")
      failure_message _("Could not create GPG Key")
      apipie_options  :without => [:content]
      option "--key", "GPG_KEY_FILE", _("GPG Key file"),
             :attribute_name => :option_content,
             :required => true,
             :format => HammerCLI::Options::Normalizers::File.new
    end

    class UpdateCommand < HammerCLIKatello::UpdateCommand
      success_message _("GPG Key updated")
      failure_message _("Could not update GPG Key")
      resource KatelloApi::Resources::GpgKey, :update

      identifiers :id

      def request_params
        super.merge(method_options)
      end

      apipie_options :without => [:content]
      option "--key", "GPG_KEY_FILE", _("GPG Key file"),
             :attribute_name => :option_content,
             :format => HammerCLI::Options::Normalizers::File.new
    end

    class DeleteCommand < HammerCLIKatello::DeleteCommand
      success_message _("GPG Key deleted")
      failure_message _("Could not delete the GPG Key")
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
                                    _("manipulate GPG Key actions on the server"),
                                    HammerCLIKatello::GpgKeyCommand)
end
