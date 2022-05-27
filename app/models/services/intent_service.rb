module Services
  class IntentService < ApplicationService
    def initialize(alexa_response:, intent:, data:)
      @alexa_response = alexa_response
      @intent = intent
      @data = data
    end

    def call
      create_intent
    end

    def create_intent
      return @alexa_response.body unless @alexa_response
      return @alexa_response.body unless @intent

      case @intent[:name]
      when 'PcCommands' then return ComputerService.call(alexa_response: @alexa_response, slots: @intent[:slots], data: @data)
      else return @alexa_response.body
      end
    end
  end
end
