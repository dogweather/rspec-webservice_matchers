module RSpec
  module WebserviceMatchers
    module RedirectHelpers
      def redirect_failure_message(exception, status, actual_location, kind:)
        return Util.error_message(exception) if exception

        errors = []
        if Util.permanent_redirect? status
          errors << 'received a permanent redirect'
        end
        unless expected_location? expected, actual_location
          errors << "received location #{actual_location}"
        end
        unless Util.redirect? status
          errors << "not a redirect: received status #{status}"
        end

        Util.error_message(errors)
      end

      def expected_location?(expected, actual)
        actual =~ %r{#{expected}/?}
      end

      def redirect?(status)
        temp_redirect?(status) || permanent_redirect?(status)
      end

      def temp_redirect?(status)
        [302, 307].include?(status)
      end

      def permanent_redirect?(status)
        status == 301
      end
    end
  end
end
