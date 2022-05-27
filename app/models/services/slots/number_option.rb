module Services
  module Slots
    class NumberOption < SlotApplication
      def handle_slot
        return unless @slot
        return unless @data
        return unless @slot_name = @data[:slot]
        return unless @slot_class = ::Services::SlotService.get_slot_class(@slot_name)
        return unless @slot_value = @slot[:slotValue]
        return unless @selected_option = @slot_value[:value]

        @data[:selected_option] = @selected_option.to_i - 1
        @slot_class.call(alexa_response: @alexa_response, slot: @slot, data: @data, from: 'number_option')
      end
    end
  end
end
