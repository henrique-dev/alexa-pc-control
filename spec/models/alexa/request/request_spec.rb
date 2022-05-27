# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Utils::Alexa::Request, type: :model do

  let(:request_example){JSON.parse(File.read('spec/fixtures/alexa/requests/request_example.json')).deep_symbolize_keys}

  context 'create a request' do
    it 'create a alexa request' do
      alexa_request = described_class.new(params: request_example)
      expect(alexa_request.as_json.deep_symbolize_keys).to include_json(
        request_example
      )
    end
  end
end
