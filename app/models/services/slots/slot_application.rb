module Services
  module Slots
    class SlotApplication < ApplicationService
      def initialize(alexa_response:, data:, slot:, from: '')
        @alexa_response = alexa_response
        @slot = slot
        @data = data
        @from = from
      end

      def call
        handle_slot
      end

      def handle_slot
        # do nothing
      end
    end
  end
end
