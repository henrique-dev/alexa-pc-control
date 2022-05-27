module Utils
  module Alexa
    class Request < Dry::Struct
      attribute :version,               Dry::Types['string']
      attribute :session,               Dry::Types['hash']
      attribute :context,               Dry::Types['hash']
      attribute :request,               Dry::Types['hash']
    end
  end
end
