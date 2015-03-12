require 'rspec/webservice_matchers/util'

module RSpec
  module WebserviceMatchers
    # Do we get a 302 or 307 to the place we intend?
    RSpec::Matchers.define :redirect_temporarily_to do |expected|
      include RSpec
      error_message = status = actual_location = nil

      match do |url_or_domain_name|
        begin
          status, headers = Util.head(url_or_domain_name)
          actual_location = headers['location']

          [302, 307].include?(status) && (/#{expected}\/?/ =~ actual_location)
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
          if status == 301
            mesgs << "received a permanent redirect, status #{status}"
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