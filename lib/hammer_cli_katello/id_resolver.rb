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

    def organization_id(options)
      # Dedicated getter for organization ids that solves id inconsistency in Katello vs Foreman
      # Foreman orgs use numeric identifiers while katello routes require labels. Therefore
      # this id resolver always return labels.
      key = HammerCLI.option_accessor_name("id")
      if options[key]
        organization_by_id(options[key])['label']
      else
        find_resource(:organizations, options)['label']
      end
    end

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

    private

    def organization_by_id(numeric_id)
      org = @api.resource(:organizations).call(:show, :id => numeric_id)
      org = HammerCLIForeman.record_to_common_format(org)
      org
    end

  end

end
