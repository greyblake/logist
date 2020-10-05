require 'json'
require 'logger'
require 'rails'

module Logist
  module Formatter
    class Json < ::Logger::Formatter
      attr_accessor :flat_json

      def call(severity, timestamp, progname, msg)
        payload = { level: severity, timestamp: format_datetime(timestamp), environment: ::Rails.env }
        normalized_msg = normalize_message(msg)

        if flat_json && msg.is_a?(Hash)
          payload.merge!(normalized_msg)
        else
          payload.merge!(message: normalized_msg)
        end

        payload.to_json << "\n"
      end

      private

      def normalize_message(msg)
        if msg.is_a?(String)
          JSON.parse(msg)
        else
          msg
        end
      rescue JSON::ParserError
        msg
      end
    end
  end
end
