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
    end
  end
end
