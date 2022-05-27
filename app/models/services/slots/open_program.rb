module Services
  module Slots
    class OpenProgram < SlotApplication
      def handle_slot
        return unless @slot

        if resolutions = @slot[:resolutions]
          handle_with_resolutions(resolutions)
        end
        handle_with_options if @from.match?('option')
      end

      private
      def handle_with_resolutions(resolutions)
        return unless resolutions_per_authority = resolutions[:resolutionsPerAuthority]

        resolutions_per_authority.each_with_index do |resolution, _index|
          next unless resolution[:status][:code].match?('ER_SUCCESS_MATCH')
          next unless value = resolution[:values].first
          next unless program_name = value[:value][:id]
          next unless program = Alexa::Program.find_by(name: program_name)

          handle_with_program(program)
        end
      end

      def handle_with_options
        return unless program = Alexa::Program.find_by(name: @data[:program])

        handle_with_program(program)
      end

      def handle_with_program(program)
        case program.type
        when 'execute' then execute_program(program)
        when 'list_and_execute' then list_and_execute_program(program)
        end
      end

      def execute_program(program)
        # execute a program
      end

      def list_and_execute_program(program)
        current_step = 0 unless current_step = @data[:step]

        case current_step
        when 0
          return unless response_body = Services::CommunicationService.call(route: program.routes[current_step])
          return unless object = JSON.parse(response_body).deep_symbolize_keys

          @alexa_response.should_not_end_session!
          @alexa_response.add_session_attribute(:options, object[:options])
          @alexa_response.add_session_attribute(:slot, :open_program)
          @alexa_response.add_session_attribute(:program, program.name)
          @alexa_response.add_session_attribute(:step, current_step + 1)

          @alexa_response.add_ssml_output_speech(program.prompts[current_step])
          object[:options].each_with_index do |option, index|
            @alexa_response.concat_ssml_output_speech("\n<break time='1s'/>Opção #{index+1}: #{option[:name]}")
          end

        when 1
          @alexa_response.should_end_session!
          Services::CommunicationService.call(route: program.routes[current_step], params: {name: @data[:options][@data[:selected_option]][:name]})
          @alexa_response.add_text_output_speech("#{program.prompts[current_step]} #{@data[:options][@data[:selected_option]][:name]}")
        end
      rescue Services::CommunicationService::ComputerNotConfigured => exception
        @alexa_response.add_text_output_speech("Parece que não existe um computador configurado")
      rescue StandardError => exception
        @alexa_response.add_text_output_speech("Desculpe, ocorreu algun erro ao tentar abrir o programa")
      end
    end
  end
end
