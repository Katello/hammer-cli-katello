module HammerCLIKatello
  module Output
    module Formatters

      class ChecksumFormatter < HammerCLI::Output::Formatters::FieldFormatter

        def tags
          [:screen]
        end

        def format(items, _ = {})
          "%s  %s" % items.reverse
        end
      end

      class DependencyFormatter < HammerCLI::Output::Formatters::FieldFormatter

        def format(dependency, _ = {})
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
end
