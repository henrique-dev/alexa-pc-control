module Services
  class CommunicationService < ApplicationService

    class ComputerNotConfigured < ::StandardError; end
    class ComputerIpNotConfigured < ComputerNotConfigured; end
    class ComputerNameNotConfigured < ComputerNotConfigured; end
    class ComputerPortNotConfigured < ComputerNotConfigured; end

    def initialize(route:, params: {})
      @route = route
      @params = params
      @computer_info = Alexa::Computer.first
    end

    def call
      make_request
    end

    def make_request
      raise ComputerNotConfigured unless @computer_info
      raise ComputerIpNotConfigured unless @computer_info.network_ip
      raise ComputerPortNotConfigured unless @computer_info.network_port

      send_http_request(URI("http://#{@computer_info.network_ip}:#{@computer_info.network_port}/#{@route}"))
    end

    private
    def send_http_request(uri)
      uri.query = URI.encode_www_form( @params )
      res = Net::HTTP.get_response(uri)
      res.body if res.is_a?(Net::HTTPSuccess)
    end
  end
end
