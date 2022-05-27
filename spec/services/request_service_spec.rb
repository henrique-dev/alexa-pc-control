# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::RequestService, type: :service do

  let(:request_example){JSON.parse(File.read('spec/fixtures/alexa/requests/request_example.json')).deep_symbolize_keys}
  let(:request_without_request){JSON.parse(File.read('spec/fixtures/alexa/requests/request_without_request.json')).deep_symbolize_keys}
  let(:request_without_intent){JSON.parse(File.read('spec/fixtures/alexa/requests/request_without_intent.json')).deep_symbolize_keys}

  context 'create a request' do
    it 'dont call a intent without a request' do
      expect(Services::IntentService).to_not receive(:call)
      expect {
        described_class.call(params: request_without_request)
      }.to raise_error(Dry::Struct::Error)
    end

    it 'dont call a intent without a intent' do
      expect(Services::IntentService).to_not receive(:call)
      described_class.call(params: request_without_intent)
    end

    it 'call a intent with params with request and intent' do
      expect(Services::IntentService).to receive(:call)
      described_class.call(params: request_example)
    end

    context 'call a intent with params with request and intent' do
      it 'and return a valid response' do
        expect(Services::IntentService).to receive(:call).and_call_original

        response_body = described_class.call(params: request_example)

        expect(response_body).to include_json(
          {
            :version => '1.0',
            :response => {}
          }
        )
      end
    end
  end
end
