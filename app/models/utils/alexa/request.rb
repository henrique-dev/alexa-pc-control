module Utils
  module Alexa
    class Request
      attr_accessor :version
      attr_accessor :session
      attr_accessor :context
      attr_accessor :request

      def initialize(params:)
        @version = params.fetch(:version){ nil }
        @session = params.fetch(:session){ nil }
        @context = params.fetch(:context){ nil }
        @request = params.fetch(:request){ nil }
      end
    end
  end
end
