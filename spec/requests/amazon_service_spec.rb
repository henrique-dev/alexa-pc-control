require 'rails_helper'

RSpec.describe '/amazon_service', type: :request do

  let(:request_example){JSON.parse(File.read('spec/fixtures/alexa/requests/request_example.json')).deep_symbolize_keys}

  let(:valid_attributes) {
    request_example
  }

  let(:invalid_attributes) {
    skip('Add a hash of attributes invalid for your model')
  }

  describe 'POST /create' do
    it 'renders a successful response' do
      post amazon_service_index_path(format: :json, params: request_example)
      expect(response).to be_successful
    end

    it 'have a valid default response body' do
      post amazon_service_index_path(format: :json, params: request_example)
      expect(response.body).to include_json(
        {
          'version' => '1.0',
          'response': {
            'outputSpeech': {
              'type': 'PlainText',
              'text': 'Desculpe, não consegui processar isto'
            },
            'shouldEndSession': true
          }
        }
      )
    end

    context 'when we call programs' do
      context 'and use virtual box' do

        let(:request_to_list_virtual_machines){JSON.parse(File.read('spec/fixtures/alexa/requests/request_example.json')).deep_symbolize_keys}

        it 'show a list with virtual machine names' do
          post amazon_service_index_path(format: :json, params: request_to_list_virtual_machines)
          expect(response.body).to include_json(
            {
              'version' => '1.0',
              'response': {
                'outputSpeech': {
                  'type': 'PlainText',
                  'text': 'Desculpe, não consegui processar isto'
                },
                'shouldEndSession': true
              }
            }
          )
        end
      end
    end
  end
end
