require 'rspec/webservice_matchers/util'

module RSpec
  module WebserviceMatchers
    module RedirectPermanentlyTo
      # Do we get a 301 to the place we intend?
      RSpec::Matchers.define :redirect_permanently_to do |expected|
        include RSpec
        status = actual_location = exception = nil

        match do |url_or_domain_name|
          begin
            status, headers = Util.head(url_or_domain_name)
            actual_location = headers['location']

            Util.permanent_redirect?(status) &&
              expected_location?(expected, actual_location)
          rescue Exception => e
            exception = e
            false
          end
        end

        failure_message do
          return Util.error_message(exception) if exception

          errors = []
          if Util.temp_redirect? status
            errors << "received a temporary redirect, status #{status}"
          end
          unless expected_location?(expected, actual_location)
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
end
