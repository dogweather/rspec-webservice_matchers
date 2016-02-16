require 'rspec/webservice_matchers/util'

module RSpec
  module WebserviceMatchers
    module HaveAValidCert
      # Is https is correctly implemented?
      RSpec::Matchers.define :have_a_valid_cert do
        error_message = nil

        match do |domain_name_or_url|
          begin
            Util.try_ssl_connection(domain_name_or_url)
          rescue Exception => e
            error_message = fix_for_excon_bug(e.message)
            false
          end
        end

        failure_message do
          error_message
        end

        # Excon is failing on SSL when a 302 (and possibly others) is received.
        # We _should_ be able to verify the SSL cert even though it's not a
        # 200. HTTPie and Curl are able to do it.
        # See https://github.com/excon/excon/issues/546
        def fix_for_excon_bug(error_message)
          return error_message unless buggy_excon_message?(error_message)
          'Unable to verify the certificate because a redirect was detected'
        end

        def buggy_excon_message?(text)
          text =~ /Unable to verify certificate, please/
        end
      end
    end
  end
end
