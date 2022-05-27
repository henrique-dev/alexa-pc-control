# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::ComputerService, type: :service do

  let(:request_slot_open_program){JSON.parse(File.read('spec/fixtures/alexa/requests/request_slot_open_program.json')).deep_symbolize_keys}
  let(:request_slot_open_program_virtual_machine_step1){JSON.parse(File.read('spec/fixtures/alexa/requests/request_slot_open_program_virtual_machine_step1.json')).deep_symbolize_keys}
  let(:request_slot_open_program_virtual_machine_step2){JSON.parse(File.read('spec/fixtures/alexa/requests/request_slot_open_program_virtual_machine_step2.json')).deep_symbolize_keys}
  let(:request_slot_option1_virtual_machine){JSON.parse(File.read('spec/fixtures/alexa/requests/request_slot_option1_virtual_machine.json')).deep_symbolize_keys}

  let!(:slot_open_program) { Alexa::Slot.create(name: 'open_program') }
  let!(:slot_close_program) { Alexa::Slot.create(name: 'close_program') }
  let!(:slot_power_on_component) { Alexa::Slot.create(name: 'power_on_component') }
  let!(:slot_power_off_component) { Alexa::Slot.create(name: 'power_off_component') }
  let!(:slot_search_term) { Alexa::Slot.create(name: 'search_term') }
  let!(:slot_number_option) { Alexa::Slot.create(name: 'number_option') }

  let!(:computer) { Alexa::Computer.create(network_ip: '127.0.0.1', network_name: 'henrique', network_port: '4567') }

  context 'handle with the computer service' do
    context 'using the program slot' do
      context 'using the virtual box program' do

        let(:prompt_question){ 'Qual maquina virtual voce gostaria de abrir' }
        let(:prompt_answer){ 'Abrindo a maquina virtual' }

        let!(:program_virtual_machine) {
          Alexa::Program.create(
            name: 'virtual_machine',
            type: 'list_and_execute',
            routes: ['/virtual_machine/list', '/virtual_machine/exec'],
            prompts: [prompt_question, prompt_answer])

          Alexa::Program.create(
            name: 'shell',
            type: 'list_and_execute',
            routes: ['/exec/list', '/exec'],
            prompts: ['Qual comando você gostaria de executar?', 'Executando comando'])

          # atualizar todos os repositorios
          #   - backend/  git pull origin main --rebase
          #   - frontend/ git pull origin main --rebase
          #   - manager/  git pull origin main --rebase
        }

        it 'return an array with virtual machine names (step 1)' do
          allow_any_instance_of(Services::CommunicationService)
            .to receive(:send_http_request)
            .and_return('{"options":[{"id":"Debian Dev1","name":"Debian Dev1"},{"id":"Debian Dev2","name":"Debian Dev2"},{"id":"Debian Dev3","name":"Debian Dev3"}]}')

          alexa_response = Services::RequestService.call(params: request_slot_open_program_virtual_machine_step1)
          expect(alexa_response[:version]).to eq('1.0')
          expect(alexa_response[:sessionAttributes]).to eq({
            options: [
              {id: 'Debian Dev1', name: 'Debian Dev1'},
              {id: 'Debian Dev2', name: 'Debian Dev2'},
              {id: 'Debian Dev3', name: 'Debian Dev3'}
            ],
            slot: :open_program,
            program: 'virtual_machine',
            step: 1
          })
          expect(alexa_response[:response]).to eq({
            outputSpeech: {
              type: 'SSML',
              ssml: "<speak>#{prompt_question}\n<break time='1s'/>Opção 1: Debian Dev1\n<break time='1s'/>Opção 2: Debian Dev2\n<break time='1s'/>Opção 3: Debian Dev3</speak>"
            },
            shouldEndSession: false
          })
        end

        it 'execute the virtual machine given the name (step 2)' do
          alexa_response = Services::RequestService.call(params: request_slot_option1_virtual_machine)
          expect(alexa_response[:version]).to eq('1.0')
          expect(alexa_response[:response]).to eq({
            outputSpeech: {
              type: 'PlainText',
              text: "#{prompt_answer} Debian Dev1"
            },
            shouldEndSession: true
          })
        end
      end
    end
  end

end
