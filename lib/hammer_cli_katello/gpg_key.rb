module HammerCLIKatello

  class GpgKeyCommand < HammerCLI::AbstractCommand

    class ListCommand < HammerCLIKatello::ListCommand
      resource :gpg_keys, :index

      output do
        field :id, _("ID")
        field :name, _("Name")
      end

      build_options
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      resource :gpg_keys, :show

      option '--name', 'NAME', _("GPG key name to search by")
      option '--id', 'ID', _("GPG key numeric id to search by")
      option '--organization-id', 'ORG_ID', _("Org numeric id to search by")
      option '--organization', 'ORG', _("Org numeric id to search by"), :attribute_name => :option_organization_name

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

        field :content, _("Content"), Fields::LongText
      end

      def request_params
        super.merge(method_options)
      end

      build_options :without => :id
    end

    class CreateCommand < HammerCLIKatello::CreateCommand
      resource :gpg_keys, :create

      success_message _("GPG Key created")
      failure_message _("Could not create GPG Key")

      build_options  :without => [:content]
      option "--key", "GPG_KEY_FILE", _("GPG Key file"),
             :attribute_name => :option_content,
             :required => true,
             :format => HammerCLI::Options::Normalizers::File.new
    end

    class UpdateCommand < HammerCLIKatello::UpdateCommand
      resource :gpg_keys, :update

      success_message _("GPG Key updated")
      failure_message _("Could not update GPG Key")

      def request_params
        super.merge(method_options)
      end

      build_options :without => [:content]
      option "--key", "GPG_KEY_FILE", _("GPG Key file"),
             :attribute_name => :option_content,
             :format => HammerCLI::Options::Normalizers::File.new
    end

    class DeleteCommand < HammerCLIKatello::DeleteCommand
      resource :gpg_keys, :destroy

      success_message _("GPG Key deleted")
      failure_message _("Could not delete the GPG Key")

      def request_params
        super.merge(method_options)
      end

      build_options
    end

    autoload_subcommands
  end

  HammerCLI::MainCommand.subcommand("gpg",
                                    _("manipulate GPG Key actions on the server"),
                                    HammerCLIKatello::GpgKeyCommand)
end
