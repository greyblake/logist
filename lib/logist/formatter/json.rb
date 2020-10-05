require 'json'
require 'logger'
require 'rails'

module Logist
  module Formatter
    class Json < ::Logger::Formatter
      attr_accessor :flat_json

      def call(severity, timestamp, progname, msg)
        payload = { level: severity, timestamp: format_datetime(timestamp), environment: ::Rails.env }

        if flat_json && msg.is_a?(Hash)
          payload.merge!(msg)
        else
          payload.merge!(message: format_message(msg))
        end

        payload.to_json << "\n"
      end

      def format_message(msg)
        case msg.class.name
          when "Hash"
            msg
          when "Array"
            msg
          else
            begin
              JSON.parse(msg)
            rescue JSON::ParserError
              "#{msg}"
            end
        end
      end
    end
  end
end
