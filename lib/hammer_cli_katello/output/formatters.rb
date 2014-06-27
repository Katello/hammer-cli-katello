module HammerCLIKatello::Output
  module Formatters

    class ChecksumFormatter < HammerCLI::Output::Formatters::FieldFormatter

      def tags
        [:screen]
      end

      def format(items, field_params = {})
        "%s  %s" % items.reverse
      end
    end

    class DependencyFormatter < HammerCLI::Output::Formatters::FieldFormatter

      def format(dependency, field_params = {})
        name = dependency[:name] || dependency['name']
        version = dependency[:version_requirement] || dependency['version_requirement']
        if version
          "%s ( %s )" % [name, version]
        else
          name
        end
      end
    end

    HammerCLI::Output::Output.register_formatter(ChecksumFormatter.new, :ChecksumFilePair)
    HammerCLI::Output::Output.register_formatter(DependencyFormatter.new, :Dependency)

  end
end
