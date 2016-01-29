require 'rspec/webservice_matchers/util'
require 'rspec/webservice_matchers/redirect_helpers'

module RSpec
  module WebserviceMatchers
    module RedirectPermanentlyTo
      RSpec::Matchers.define :redirect_permanently_to do |expected_location|
        include RedirectHelpers
        which_kind = :permanent
        status = actual_location = exception = nil

        match do |url_or_domain_name|
          begin
            status, headers = Util.head(url_or_domain_name)
            actual_location = headers['location']

            redirect?(status, kind: which_kind) &&
              locations_match?(expected_location, actual_location)
          rescue Exception => e
            exception = e
            false
          end
        end

        failure_message do
          redirect_failure_message(exception,
                                   status,
                                   actual_location,
                                   kind: which_kind)
        end
      end
    end
  end
end
