module Services
  class ComputerService < ApplicationService
    def initialize(alexa_response:, slots:, data:)
      @alexa_response = alexa_response
      @slots = slots
      @data = data
    end

    def call
      create_operation
    end

    def create_operation
      return @alexa_response.body unless @slots

      Alexa::Slot.each do |alexa_slot|
        next unless @slot = @slots[alexa_slot.name.to_sym]

        SlotService.call(alexa_response: @alexa_response, slot: @slot, data: @data)
      end

      @alexa_response.body
    end
  end
end
