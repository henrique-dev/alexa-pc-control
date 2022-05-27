module Services
  class RequestService < ApplicationService
    def initialize(params:)
      @alexa_response = Utils::Alexa::Response.new
      @alexa_request = Utils::Alexa::Request.new(params)
    end

    def call
      create_request
    end

    def create_request
      return @alexa_response.body unless @request = @alexa_request.request
      return @alexa_response.body unless @intent = @request[:intent]

      IntentService.call(alexa_response: @alexa_response, intent: @intent, data: @alexa_request.session[:attributes])
    end
  end
end
