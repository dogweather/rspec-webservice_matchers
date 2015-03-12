require 'faraday'

require 'rspec/webservice_matchers/util'
module RSpec
  module WebserviceMatchers
    # This is a high level matcher which checks three things:
    # 1. Permanent redirect
    # 2. to an https url
    # 3. which is correctly configured
    RSpec::Matchers.define :enforce_https_everywhere do
      error_msg = status = actual_protocol = actual_valid_cert = nil

      match do |domain_name|
        begin
          status, headers = Util.head("http://#{domain_name}")
          new_url  = headers['location']
          /^(?<protocol>https?)/ =~ new_url
          actual_protocol = protocol || nil
          actual_valid_cert = Util.valid_ssl_cert?(new_url)
          (status == 301) &&
            (actual_protocol == 'https') &&
            (actual_valid_cert == true)
        rescue Faraday::Error::ConnectionFailed
          error_msg = 'Connection failed'
          false
        end
      end

      # Create a compound error message listing all of the
      # relevant actual values received.
      failure_message do
        if !error_msg.nil?
          error_msg
        else
          mesgs = []
          if status != 301
            mesgs << "received status #{status} instead of 301"
          end
          if !actual_protocol.nil? && actual_protocol != 'https'
            mesgs << "destination uses protocol #{actual_protocol.upcase}"
          end
          if !actual_valid_cert
            mesgs << "there's no valid SSL certificate"
          end
          mesgs.join('; ').capitalize
        end
      end
    end
  end
end
