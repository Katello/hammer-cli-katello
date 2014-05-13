module HammerCLIKatello

  class Searchables

    SEARCHABLES = {
      :organization => [
        HammerCLIForeman::Searchable.new("name", _("Name to search by")),
        HammerCLIForeman::Searchable.new("label", _("Label to search by"), :editable => false)
      ]
    }

    DEFAULT_SEARCHABLES = [HammerCLIForeman::Searchable.new("name", _("Name to search by"))]

    def for(resource)
      SEARCHABLES[resource.singular_name.to_sym] || DEFAULT_SEARCHABLES
    end

  end

  class IdResolver < HammerCLIForeman::IdResolver

    def create_search_options(options, resource)
      return super if resource.name == :organizations

      searchables(resource).each do |s|
        value = options[HammerCLI.option_accessor_name(s.name.to_s)]
        if value
          return {"#{s.name}" => "#{value}"}
        end
      end
      {}
    end

  end

  class EnvironmentSearchables < Searchables

    DEFAULT_SEARCHABLES = Searchables::DEFAULT_SEARCHABLES +
      [HammerCLIForeman::Searchable.new("environment-id", _("environment id to search by"))]

    def for(resource)
      SEARCHABLES[resource.singular_name.to_sym] || DEFAULT_SEARCHABLES
    end
  end

  class UuidIdResolver < HammerCLIKatello::IdResolver

    def get_id(resource_name, options)
      options[HammerCLI.option_accessor_name("id")] || find_resource(resource_name, options)['uuid']
    end
  end
end
