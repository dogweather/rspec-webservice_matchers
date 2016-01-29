require 'rspec/webservice_matchers/util'
require 'rspec/webservice_matchers/redirect_helpers'

module RSpec
  module WebserviceMatchers
    module RedirectTemporarilyTo
      # Do we get a 302 or 307 to the place we intend?
      RSpec::Matchers.define :redirect_temporarily_to do |expected_location|
        include RedirectHelpers
        status = actual_location = exception = nil

        match do |url_or_domain_name|
          begin
            status, headers = Util.head(url_or_domain_name)
            actual_location = headers['location']

            temp_redirect?(status) &&
              expected_location?(expected_location, actual_location)
          rescue Exception => e
            exception = e
            false
          end
        end

        failure_message do
          redirect_failure_message(exception,
                                   status,
                                   actual_location,
                                   kind: :temporary)
        end
      end
    end
  end
end
