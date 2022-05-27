module Services
  module Slots
    class OpenProgram < SlotApplication
      def handle_slot
        return unless @resolutions = @slot[:resolutions]
        return unless @resolutions_per_authority = @resolutions[:resolutionsPerAuthority]

        @resolutions_per_authority.each_with_index do |resolution, _index|
          next unless resolution[:status][:code].match?('ER_SUCCESS_MATCH')
          next unless value = resolution[:values].first
          next unless program_name = value[:value][:id]
          next unless @program = Alexa::Program.find_by(name: program_name)

          case @program.type
          when 'execute' then execute_program
          when 'list_and_execute' then list_and_execute_program
          end
        end
      end

      private
      def execute_program

      end

      def list_and_execute_program
        current_step = 0 unless step = @data[:step]

        case current_step
        when 0
          response = Services::CommunicationService.call(route: @program.routes[current_step])

          @alexa_response.should_not_end_session!
          @alexa_response.add_session_attribute(:options, response[:options])
          @alexa_response.add_session_attribute(:current_resolution, @program.name)
          @alexa_response.add_session_attribute(:step, current_step + 1)

          @alexa_response.add_ssml_output_speech(@program.prompts[current_step])
          response[:options].each_with_index do |option, index|
            @alexa_response.concat_ssml_output_speech("\n<break time='1s'/>Opção #{index+1}: #{option}")
          end

        when 1

        end
      end
    end
  end
end
