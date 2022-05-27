# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Utils::Alexa::Request, type: :model do

  let(:request_example){JSON.parse(File.read('spec/fixtures/alexa/requests/request_example.json')).deep_symbolize_keys}

  context 'when have valid params' do
    it 'create a alexa request with valid params (version, session, context and request)' do
      alexa_request = described_class.new(request_example)
      expect(alexa_request.as_json.deep_symbolize_keys).to include_json(
        request_example
      )
    end
  end

  context 'when have invalid params' do
    it 'dont create a alexa request without version param' do
      request_example.delete(:version)

      expect {
        alexa_request = described_class.new(request_example)
      }.to raise_error(Dry::Struct::Error)
    end

    it 'dont create a alexa request without session param' do
      request_example.delete(:session)

      expect {
        alexa_request = described_class.new(request_example)
      }.to raise_error(Dry::Struct::Error)
    end

    it 'dont create a alexa request without context param' do
      request_example.delete(:context)

      expect {
        alexa_request = described_class.new(request_example)
      }.to raise_error(Dry::Struct::Error)
    end

    it 'dont create a alexa request without request param' do
      request_example.delete(:request)

      expect {
        alexa_request = described_class.new(request_example)
      }.to raise_error(Dry::Struct::Error)
    end
  end
end
