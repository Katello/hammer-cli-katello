module HammerCLIKatello
  module CommandExtensions
    class Ping < HammerCLI::CommandExtensions
      before_print do |data|
        unless data['results']['katello'].nil?
          data['results']['katello']['services'].each do |_, service|
            service['_response'] = get_server_response(service)
          end
          data['results'].merge!(data['results']['katello'])
        end
      end

      output do |definition|
        definition.append(HammerCLIKatello::PingCommand.output_definition.fields)
      end

      def self.get_server_response(service_hash)
        if service_hash['duration_ms']
          _("Duration: %sms") % service_hash['duration_ms']
        elsif service_hash['message']
          _("Message: %s") % service_hash['message']
        end
      end
    end
  end
end
