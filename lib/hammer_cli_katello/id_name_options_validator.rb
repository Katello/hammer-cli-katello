module HammerCLIKatello
  module IdNameOptionsValidator
    # This is a method that requires:
    # 1. either name or id has been supplied
    # 2. if name is supplied, parent id/name/etc is also required
    #
    # Normally the parent will be organization as with products, content views,
    # etc but this could also apply to repos for example whose names are unique
    # per product
    #
    # Some examples:
    #
    # validate_id_or_name_with_parent
    # validate_id_or_name_with_parent :content_view
    # validate_id_or_name_with_parent :repository, parent: 'product', required: false
    # validate_id_or_name_with_parent :content_view, parent: {organization: ['id', 'name']}
    def validate_id_or_name_with_parent(record_name = nil, parent: 'organization', required: true)
      child_options = IdNameOptionsValidator.build_child_options(record_name)
      parent_options = IdNameOptionsValidator.build_parent_options(parent)

      validate_options :before, 'IdResolution' do
        any(*child_options).required if required

        if (name_option = child_options.detect { |opt| opt.end_with?('_name') }) &&
           option(name_option).exist?
          any(*parent_options).required
        end
      end
    end

    # This method simply checks that either id or name is supplied
    #
    # Some examples:
    #
    # # checks for a --id or --name option
    # validate_id_or_name
    # # checks for --content-view-id or --content-view-name
    # validate_id_or_name :content_view
    def validate_id_or_name(record_name = nil)
      child_options = IdNameOptionsValidator.build_child_options(record_name)

      validate_options do
        any(*child_options).required
      end
    end

    def self.build_child_options(record_name)
      if record_name.nil?
        %w[option_id option_name]
      else
        IdNameOptionsValidator.build_options(record_name, %w[id name])
      end
    end

    def self.build_parent_options(parent)
      if parent.is_a?(String) || parent.is_a?(Symbol)
        opts = parent.to_s == 'organization' ? %w[id name label] : %w[id name]
      elsif parent.is_a?(Hash)
        parent, opts = parent.first.to_a
      else
        raise "Unkown parent class: #{parent.class} for #{parent}"
      end

      IdNameOptionsValidator.build_options(parent, opts)
    end

    def self.build_options(record_name, options)
      options.map do |opt|
        "option_#{record_name}_#{opt}"
      end
    end
  end
end
