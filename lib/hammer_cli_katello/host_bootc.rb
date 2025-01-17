module HammerCLIKatello
  class HostBootc < HammerCLIKatello::Command
    resource :host_bootc_images
    desc "Manage bootc images on your hosts"

    class ImagesCommand < HammerCLIKatello::ListCommand
      action :bootc_images
      command_name "images"

      output do
        field :bootc_booted_image, _("Running image")
        field :bootc_booted_digest, _("Running image digest")
        field :host_count, _("Host count")
      end

      def send_request
        self.class.parse_data(super)
      end

      def self.parse_data(data_collection)
        data = data_collection.inject([]) do |list, item|
          list + item["digests"].collect do |digest|
            digest.merge(:bootc_booted_image => item["bootc_booted_image"])
          end
        end
        HammerCLI::Output::RecordCollection.new(data, :meta => data_collection.meta)
      end

      build_options
    end

    autoload_subcommands
  end
end
