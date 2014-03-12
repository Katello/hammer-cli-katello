
module HammerCLIKatello
  class ExceptionHandler < HammerCLIForeman::ExceptionHandler

    def mappings
      super + [
        [RestClient::InternalServerError, :handle_internal_error]
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

    def handle_katello_error(e)
      response = JSON.parse(e.response)
      response = HammerCLIForeman.record_to_common_format(response)
      print_error response["displayMessage"] || response["full_messages"]
    end

  end
end
