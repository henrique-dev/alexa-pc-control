module Services
  class CommunicationService < ApplicationService
    def initialize(route:, params: {})
      @route = route
      @params = params
    end

    def call
      create_request
    end

    def create_request
      uri = URI("http://192.168.15.25:4567/#{@route}")
      uri.query = URI.encode_www_form( @params )
      res = Net::HTTP.get_response(uri)
      res.body if res.is_a?(Net::HTTPSuccess)
    end
  end
end
