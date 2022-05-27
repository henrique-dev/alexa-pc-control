module Services
  class SlotService < ApplicationService
    def initialize(alexa_response:, slot:, data:)
      @alexa_response = alexa_response
      @slot = slot
      @data = data
    end

    def call
      create_slot
    end

    def create_slot
      return @alexa_response.body unless @slot
      return unless slot_class = get_slot_class(@slot[:name])

      slot_class.call(alexa_response: @alexa_response, slot: @slot, data: @data)
    end

    private
    def get_slot_class(slot_name)
      "Services::Slots::#{slot_name.camelize}".constantize
    end
  end
end
