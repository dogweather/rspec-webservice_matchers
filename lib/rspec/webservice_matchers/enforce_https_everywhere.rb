require 'faraday'
require 'rspec/webservice_matchers/util'

module RSpec
  module WebserviceMatchers
    module EnforceHttpsEverywhere
      # This is a high level matcher which checks three things:
      # 1. Permanent redirect
      # 2. to an https url
      # 3. which is correctly configured
      RSpec::Matchers.define :enforce_https_everywhere do
        error_msg = status = final_protocol = has_valid_cert = nil

        match do |domain_name|
          begin
            status, new_url, final_protocol = get_info(domain_name)
            meets_expectations?(status, final_protocol, Util.valid_cert?(new_url))
          rescue Faraday::Error::ConnectionFailed
            error_msg = 'Connection failed'
            false
          end
        end

        def get_info(domain_name)
          status, headers = Util.head(domain_name)
          location = headers['location']
          /^(https?)/ =~ location
          protocol = $1 || nil
          [status, location, protocol]
        end

        def meets_expectations?(status, protocol, valid_cert)
          (status == 301) && (protocol == 'https') && valid_cert
        end

        # Create a compound error message listing all of the
        # relevant actual values received.
        failure_message do
          error_msg || higher_level_errors(status, final_protocol, has_valid_cert)
        end

        def higher_level_errors(status, protocol, cert_is_valid)
          mesgs = []
          mesgs << "received status #{status} instead of 301" if status != 301
          if !protocol.nil? && protocol != 'https'
            mesgs << "destination uses protocol #{protocol.upcase}"
          end
          mesgs << "there's no valid SSL certificate" unless cert_is_valid
          mesgs.join('; ').capitalize
        end
      end
    end
  end
end
