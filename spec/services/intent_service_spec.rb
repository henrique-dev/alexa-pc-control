# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::IntentService, type: :service do

  let(:request_example){JSON.parse(File.read('spec/fixtures/alexa/requests/request_example.json')).deep_symbolize_keys}
  let(:request_without_request){JSON.parse(File.read('spec/fixtures/alexa/requests/request_without_request.json')).deep_symbolize_keys}
  let(:request_without_intent){JSON.parse(File.read('spec/fixtures/alexa/requests/request_without_intent.json')).deep_symbolize_keys}

  context 'create a intent' do
    it 'dont call a PcCommands without the intent name as PcCommands' do
      request_example[:request][:intent][:name] = nil

      expect(Services::ComputerService).to_not receive(:call)
      Services::RequestService.call(params: request_example)
    end

    it 'call a PcCommands with the intent name as PcCommands' do
      expect(Services::ComputerService).to receive(:call)
      Services::RequestService.call(params: request_example)
    end
  end
end
