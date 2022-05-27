module Utils
  module Alexa
    class Response

      attr_accessor :body

      def initialize
        @body = {
          version: "1.0",
          sessionAttributes: {},
          response: {
            outputSpeech: {
              type: "PlainText",
              text: "Desculpe, não consegui processar isto",
              # playBehavior: "REPLACE_ENQUEUED"
            },
            # card: {
            #   type: "Standard",
            #   title: "Title of the card",
            #   text: "Text content for a standard card",
            #   # image: {
            #   #   smallImageUrl: "https://url-to-small-card-image...",
            #   #   largeImageUrl: "https://url-to-large-card-image..."
            #   # }
            # },
            # reprompt: {
            #   outputSpeech: {
            #     type: "PlainText",
            #     text: "Desculpe, não consegui processar isto",
            #     # playBehavior: "REPLACE_ENQUEUED"
            #   }
            # },
            # directives: [
            #   {
            #     type: "InterfaceName.Directive"
            #   }
            # ],
            shouldEndSession: true
          }
        }
      end

      def add_ssml_output_speech(ssml)
        @body[:response][:outputSpeech] = {
          type: 'SSML',
          ssml: "<speak>#{ssml}</speak>"
        }
      end

      def add_text_output_speech(text)
        @body[:response][:outputSpeech] = {
          type: 'PlainText',
          text: text
        }
      end

      def concat_text_output_speech(text)
        @body[:response][:outputSpeech][:text] << text
      end

      def concat_ssml_output_speech(ssml)
        raw_ssml = @body[:response][:outputSpeech][:ssml].split(/<speak>|<\/speak>/).join('')
        raw_ssml << ssml
        @body[:response][:outputSpeech][:ssml] = "<speak>#{raw_ssml}</speak>"
      end

      def add_reprompt_output_speech(type, text)
        @body[:response][:reprompt] = {
          outputSpeech: {
            type: type,
            text: text
          }
        }
      end

      def add_session_attribute(key, value)
        @body[:sessionAttributes][key] = value
      end

      def should_end_session!
        @body[:response][:shouldEndSession] = true
      end

      def should_not_end_session!
        @body[:response][:shouldEndSession] = false
      end
    end
  end
end
