module HammerCLIKatello

  class GpgKeyCommand < HammerCLIForeman::Command

    resource :gpg_keys

    class ListCommand < HammerCLIKatello::ListCommand

      output do
        field :id, _("ID")
        field :name, _("Name")
      end

      build_options
    end

    class InfoCommand < HammerCLIKatello::InfoCommand

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

      build_options
    end

    class CreateCommand < HammerCLIKatello::CreateCommand
      success_message _("GPG Key created")
      failure_message _("Could not create GPG Key")

      build_options  :without => [:content]
      option "--key", "GPG_KEY_FILE", _("GPG Key file"),
             :attribute_name => :option_content,
             :required => true,
             :format => HammerCLI::Options::Normalizers::File.new
    end

    class UpdateCommand < HammerCLIKatello::UpdateCommand
      success_message _("GPG Key updated")
      failure_message _("Could not update GPG Key")

      build_options :without => [:content]
      option "--key", "GPG_KEY_FILE", _("GPG Key file"),
             :attribute_name => :option_content,
             :format => HammerCLI::Options::Normalizers::File.new
    end

    class DeleteCommand < HammerCLIKatello::DeleteCommand
      success_message _("GPG Key deleted")
      failure_message _("Could not delete the GPG Key")

      build_options
    end

    autoload_subcommands
  end

end
