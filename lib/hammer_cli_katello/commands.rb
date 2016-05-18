module HammerCLIKatello
  RESOURCE_NAME_MAPPING = {
    :system => :content_host
  }.freeze

  module ResolverCommons
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def resolver
        api = HammerCLI::Connection.get("foreman").api
        HammerCLIKatello::IdResolver.new(api, HammerCLIKatello::Searchables.new)
      end

      def searchables
        @searchables ||= HammerCLIKatello::Searchables.new
        @searchables
      end

      def resource_name_mapping
        HammerCLIKatello::RESOURCE_NAME_MAPPING.dup
      end
    end
  end

  class Command < HammerCLIForeman::Command
    include HammerCLIKatello::ResolverCommons
  end

  class SingleResourceCommand < HammerCLIForeman::SingleResourceCommand
    include HammerCLIKatello::ResolverCommons
  end

  class ListCommand < HammerCLIForeman::ListCommand
    include HammerCLIKatello::ResolverCommons
  end

  class InfoCommand < HammerCLIForeman::InfoCommand
    include HammerCLIKatello::ResolverCommons
  end

  class CreateCommand < HammerCLIForeman::CreateCommand
    include HammerCLIKatello::ResolverCommons
  end

  class UpdateCommand < HammerCLIForeman::UpdateCommand
    include HammerCLIKatello::ResolverCommons
  end

  class DeleteCommand < HammerCLIForeman::DeleteCommand
    include HammerCLIKatello::ResolverCommons
  end

  class AddAssociatedCommand < HammerCLIForeman::AddAssociatedCommand
    include HammerCLIKatello::ResolverCommons
  end

  class RemoveAssociatedCommand < HammerCLIForeman::RemoveAssociatedCommand
    include HammerCLIKatello::ResolverCommons
  end
end
