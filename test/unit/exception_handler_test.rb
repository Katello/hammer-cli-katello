require_relative '../test_helper'
require 'hammer_cli_katello/exception_handler'

describe HammerCLIKatello::ExceptionHandler do
  let(:handler) { HammerCLIKatello::ExceptionHandler.new }

  describe '#mappings' do
    it 'includes UnprocessableEntity mapping' do
      mappings = handler.mappings
      unprocessable_mapping = mappings.find { |m| m[0] == RestClient::UnprocessableEntity }

      _(unprocessable_mapping).wont_be_nil
      _(unprocessable_mapping[1]).must_equal :handle_unprocessable_entity
    end

    it 'includes InternalServerError mapping' do
      mappings = handler.mappings
      internal_error_mapping = mappings.find { |m| m[0] == RestClient::InternalServerError }

      _(internal_error_mapping).wont_be_nil
      _(internal_error_mapping[1]).must_equal :handle_internal_error
    end

    it 'includes BadRequest mapping' do
      mappings = handler.mappings
      bad_request_mapping = mappings.find { |m| m[0] == RestClient::BadRequest }

      _(bad_request_mapping).wont_be_nil
      _(bad_request_mapping[1]).must_equal :handle_bad_request
    end
  end

  describe '#handle_unprocessable_entity' do
    it 'extracts and prints displayMessage from API response' do
      error_response_body = {
        'displayMessage' => 'Validation failed: Host example.com: Cannot add content view environment to content facet.',
        'errors' => {
          'base' => ['Host example.com: Cannot add content view environment to content facet.']
        }
      }.to_json

      # RestClient exceptions expect the response to be accessible as a string
      exception = RestClient::UnprocessableEntity.new
      exception.instance_variable_set(:@response, error_response_body)

      # Capture the output
      output = StringIO.new
      handler.stub :print_error, ->(msg) { output.puts(msg) } do
        handler.stub :log_full_error, ->(_) {} do
          result = handler.send(:handle_unprocessable_entity, exception)
          _(result).must_equal HammerCLI::EX_DATAERR
          _(output.string).must_include 'Validation failed'
          _(output.string).must_include 'Cannot add content view environment'
        end
      end
    end

    it 'falls back to exception message if JSON parsing fails' do
      # Create a mock response that responds to code but has invalid JSON body
      response_mock = 'Not valid JSON'
      response_mock.define_singleton_method(:code) { 422 }

      exception = RestClient::UnprocessableEntity.new
      exception.instance_variable_set(:@response, response_mock)

      output = StringIO.new
      handler.stub :print_error, ->(msg) { output.puts(msg) } do
        handler.stub :log_full_error, ->(_) {} do
          result = handler.send(:handle_unprocessable_entity, exception)
          _(result).must_equal HammerCLI::EX_DATAERR
          # When JSON parsing fails, it should fall back to the exception message
          _(output.string).wont_be_empty
        end
      end
    end
  end
end
