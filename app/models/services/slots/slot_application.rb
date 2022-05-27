module Services
  module Slots
    class SlotApplication < ApplicationService
      def initialize(alexa_response:, data:, slot:)
        @alexa_response = alexa_response
        @slot = slot
        @data = data
      end

      def call
        handle_slot
      end

      def handle_slot

      end
    end
  end
end
