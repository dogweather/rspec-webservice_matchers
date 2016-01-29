require 'rspec/webservice_matchers/util'

module RSpec
  module WebserviceMatchers
    module RedirectTemporarilyTo
      # Do we get a 302 or 307 to the place we intend?
      RSpec::Matchers.define :redirect_temporarily_to do |expected|
        include RSpec
        error_message = status = actual_location = nil

        match do |url_or_domain_name|
          begin
            status, headers = Util.head(url_or_domain_name)
            actual_location = headers['location']

            Util.temp_redirect?(status) && expected_location?(expected, actual_location)
          rescue Exception => e
            error_message = e.message
            false
          end
        end

        failure_message do
          if !error_message.nil?
            error_message
          else
            mesgs = []
            if Util.permanent_redirect? status
              mesgs << 'received a permanent redirect'
            end
            unless expected_location? expected, actual_location
              mesgs << "received location #{actual_location}"
            end
            unless Util.redirect? status
              mesgs << "not a redirect: received status #{status}"
            end
            mesgs.join('; ').capitalize
          end
        end

        def expected_location?(expected, actual)
          actual =~ %r{#{expected}/?}
        end
      end
    end
  end
end
