# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::ComputerService, type: :service do

  let(:request_slot_open_program){JSON.parse(File.read('spec/fixtures/alexa/requests/request_slot_open_program.json')).deep_symbolize_keys}

  before do
    Alexa::Slot.create(name: 'open_program')
    Alexa::Slot.create(name: 'close_program')
    Alexa::Slot.create(name: 'power_on_component')
    Alexa::Slot.create(name: 'power_off_component')
    Alexa::Slot.create(name: 'search_term')

    Alexa::Program.create(name: 'virtual_machine', type: 'list_and_execute',
                          paths: ['/one/two/', '/one/two/'], commands: ['list', 'exec'],
                          routes: ['/virtual_machine/list', '/virtual_machine/exec'],
                          prompts: ['Qual maquina virtual voce gostaria de abrir', ''])
  end

  context 'handle with the computer service' do
    context 'using the program slot' do
      context 'using the virtual box program' do
        it 'return an array with virtual machine names' do
          allow_any_instance_of(Services::CommunicationService)
            .to receive(:create_request)
            .and_return({
              options: ['Debian Dev1', 'Debian Dev2', 'Debian Dev3']
            })

          alexa_response = Services::RequestService.call(params: request_slot_open_program)
          expect(alexa_response[:version]).to eq('1.0')
          expect(alexa_response[:sessionAttributes]).to eq({
            options: ['Debian Dev1', 'Debian Dev2', 'Debian Dev3'],
            current_resolution: 'virtual_machine',
            step: 1
          })
          expect(alexa_response[:response]).to eq({
            outputSpeech: {
              type: 'SSML',
              ssml: "<speak>Qual maquina virtual voce gostaria de abrir\n<break time='1s'/>Opção 1: Debian Dev1\n<break time='1s'/>Opção 2: Debian Dev2\n<break time='1s'/>Opção 3: Debian Dev3</speak>"
            },
            shouldEndSession: false
          })
        end
      end
    end
  end

end
