
module HammerCLIKatello
  class ExceptionHandler < HammerCLIForeman::ExceptionHandler
    def mappings
      super + [
        [RestClient::InternalServerError, :handle_internal_error],
        [RestClient::BadRequest, :handle_bad_request]
      ]
    end

    protected

    def handle_internal_error(e)
      handle_katello_error(e)
      HammerCLI::EX_SOFTWARE
    end

    def handle_unprocessable_entity(e)
      handle_katello_error(e)
      HammerCLI::EX_DATAERR
    end

    def handle_not_found(e)
      handle_katello_error(e)
      HammerCLI::EX_NOT_FOUND
    end

    def handle_bad_request(e)
      handle_katello_error(e)
      HammerCLI::EX_NOT_FOUND
    end

    def handle_katello_error(e)
      begin
        response = JSON.parse(e.response)
        response = HammerCLIForeman.record_to_common_format(response)
        # Check multiple possible keys that can contain error message:
        # - displayMessage for katello specific messages
        # - full_messages for for messages that come from rails
        # - message for foreman specific messages
        msg = response["displayMessage"] || response["full_messages"] || response["message"]
      rescue JSON::ParserError
        msg = e.message
      ensure
        msg ||= e.message
      end
      print_error(msg)
      log_full_error(e)
    end
  end
end
