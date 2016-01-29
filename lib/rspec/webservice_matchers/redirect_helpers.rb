require 'rspec/webservice_matchers/util'

module RSpec
  module WebserviceMatchers
    module RedirectHelpers
      def redirect_failure_message(exception, status, actual_location, kind:)
        return Util.error_message(exception) if exception

        errors = []
        unless redirect? status, kind: kind
          errors << "received a #{kind_for(status)} redirect"
        end
        unless expected_location? expected, actual_location
          errors << "received location #{actual_location}"
        end
        unless redirect? status
          errors << "not a redirect: received status #{status}"
        end

        Util.error_message(errors)
      end

      def expected_location?(expected, actual)
        actual =~ %r{#{expected}/?}
      end

      def redirect?(status, kind: nil)
        case kind
        when :permanent
          permanent_redirect?(status)
        when :temporary
          temp_redirect?(status)
        else
          temp_redirect?(status) || permanent_redirect?(status)
        end
      end

      def temp_redirect?(status)
        [302, 307].include?(status)
      end

      def permanent_redirect?(status)
        status == 301
      end

      def kind_for(status)
        {
          301 => 'permanent',
          302 => 'temporary',
          307 => 'temporary'
        }[status]
      end
    end
  end
end
