module HammerCLIKatello
  class ContentCredentialCommand < HammerCLIForeman::Command
    resource :content_credentials

    class ListCommand < HammerCLIKatello::ListCommand
      output do
        field :id, _('Id')
        field :name, _('Name')
        field :content_type, _('Content Type')
      end

      build_options
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      output do
        field :id, _('Id')
        field :name, _('Name')
        from :organization do
          field :name, _('Organization')
        end

        collection :repositories, 'Repositories' do
          field :id, _('Id')
          field :name, _('Name')
          field :content_type, _('Content Type')
          from :product do
            field :name, _('Product')
          end
        end

        field :content, _('Content'), Fields::LongText
      end

      build_options
    end

    class CreateCommand < HammerCLIKatello::CreateCommand
      success_message _('Content Credential created.')
      failure_message _('Could not create Content Credential')

      build_options :without => [:content]
      option '--path', 'KEY_FILE', _('Key file'),
             :attribute_name => :option_content,
             :required => true,
             :format => HammerCLI::Options::Normalizers::File.new
    end

    class UpdateCommand < HammerCLIKatello::UpdateCommand
      success_message _('Content Credential updated.')
      failure_message _('Could not update Content Credential')

      build_options :without => [:content]
      option '--path', 'KEY_FILE', _('Key file'),
             :attribute_name => :option_content,
             :format => HammerCLI::Options::Normalizers::File.new
    end

    class DeleteCommand < HammerCLIKatello::DeleteCommand
      success_message _('Content Credential deleted.')
      failure_message _('Could not delete the Content Credential')

      build_options
    end

    autoload_subcommands
  end
end
