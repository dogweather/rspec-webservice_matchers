require 'rspec/webservice_matchers/util'
require 'rspec/webservice_matchers/redirect_helpers'

module RSpec
  module WebserviceMatchers
    module RedirectTemporarilyTo
      RSpec::Matchers.define :redirect_temporarily_to do |expected_location|
        include RedirectHelpers
        kind = :temporary
        status = actual_location = exception = nil

        match do |url_or_domain_name|
          begin
            status, actual_location = redirect_result(url_or_domain_name)
            redirects_correctly?(status, actual_location, expected_location, kind)
          rescue Faraday::ConnectionFailed => e
            exception = e
            false
          end
        end

        failure_message do
          redirect_failure_message(exception,
                                   status,
                                   actual_location,
                                   kind: kind)
        end
      end
    end
  end
end
