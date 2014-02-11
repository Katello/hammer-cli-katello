module HammerCLIKatello

  # TODO: Add as an official normalizer in hammer-cli (i.e. options/normalizers.rb)
  class JSONInput < HammerCLI::Options::Normalizers::File
    def format(val)
      # The JSON input could be the path to a file whose contents are
      # JSON or a JSON string. (e.g. JSON string =
      # '{ "units":[ { "name":"zip", "version":"9.0", "inclusion":"false" } ] }')
      json_string = ::File.exist?(val) ? super(val) : val
      JSON.parse(json_string)
    end
  end

  class Filter < HammerCLI::Apipie::Command

    resource KatelloApi::Resources::Filter
    command_name 'filter'
    desc 'View and manage filters'

    class ListCommand < HammerCLIKatello::ListCommand
      output do
        field :id, "Filter ID"
        field :name, "Name"
        field :type, "Type"
      end

      apipie_options
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      output do
        field :id, "Filter ID"
        field :name, "Name"
        field :type, "Type"

        collection :repositories, "Repositories" do
          field :id, "ID"
          field :name, "Name"
          field :label, "Label"
        end

        label "Parameters" do
          from :parameters do
            collection :units, "Units" do
              field :id, "ID"
              field :name, "Name"
              field :author, "Author"
              field :version, "Version"
              field :min_version, "Minimum Version"
              field :max_version, "Maximum Version"
              field :inclusion, "Include"
              field :created_at, "Created"
            end

            label "Date Range" do
              from :date_range do
                field :start, "Start Date"
                field :end, "End Date"
              end
            end

            field :inclusion, "Include"
            field :created_at, "Created"
          end
        end
      end

      apipie_options
    end

    class CreateCommand < HammerCLIKatello::CreateCommand
      success_message "Filter created"
      failure_message "Could not create the filter"

      apipie_options :without => [:parameters]
      option "--parameters", "PARAMETERS",
             "Filter parameters as either a JSON string or path to file containing JSON",
             :attribute_name => :option_parameters,
             :format => JSONInput.new
    end

    class UpdateCommand < HammerCLIKatello::UpdateCommand
      success_message "Filter updated"
      failure_message "Could not update the filter"

      apipie_options :without => [:parameters]
      option "--parameters", "PARAMETERS",
             "Filter parameters as either a JSON string or path to file containing JSON",
             :attribute_name => :option_parameters,
             :format => JSONInput.new
    end

    class DeleteCommand < HammerCLIKatello::DeleteCommand
      success_message "Filter deleted"
      failure_message "Could not delete the filter"

      apipie_options
    end

    include HammerCLIKatello::AssociatingCommands::Repository

    autoload_subcommands
  end
end
