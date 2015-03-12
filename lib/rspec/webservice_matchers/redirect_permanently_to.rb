require 'rspec/webservice_matchers/util'

module RSpec
  module WebserviceMatchers
    module RedirectPermanentlyTo
      # Do we get a 301 to the place we intend?
      RSpec::Matchers.define :redirect_permanently_to do |expected|
        error_message = status = actual_location = nil

        match do |url_or_domain_name|
          begin
            status, headers = Util.head(url_or_domain_name)
            actual_location = headers['location']

            (status == 301) && (/#{expected}\/?/.match(actual_location))
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
            if [302, 307].include? status
              mesgs << "received a temporary redirect, status #{status}"
            end
            if !actual_location.nil? && ! (%r|#{expected}/?| === actual_location)
              mesgs << "received location #{actual_location}"
            end
            if ![301, 302, 307].include? status
              mesgs << "not a redirect: received status #{status}"
            end
            mesgs.join('; ').capitalize
          end
        end
      end
    end
  end
end
