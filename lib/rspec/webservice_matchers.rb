require 'rspec/webservice_matchers/version'
require 'curb'

module RSpec
  module WebserviceMatchers

    def self.has_valid_ssl_cert?(domain_name)
      begin
        Curl.get "https://#{domain_name}"  # Faster than Curl.head; not sure why.
        return true
      rescue Curl::Err::ConnectionFailedError, Curl::Err::SSLCACertificateError, Curl::Err::SSLPeerCertificateError
        # Not serving SSL, expired, or incorrect domain name
        return false
      end
    end

    #
    # Custom RSpec matcher: have_a_valid_cert
    #
    RSpec::Matchers.define :have_a_valid_cert do
      match do |domain_name|
        RSpec::WebserviceMatchers.has_valid_ssl_cert?(domain_name)
      end
    end


    # Would this matcher be helpful?

    #
    # Return true if the domain serves content via SSL
    # without checking certificate validity.
    #
    # def self.supports_ssl?(domain_name)
    #   begin
    #     has_valid_ssl_cert?(domain_name)
    #     # Cert may not be valid, but content IS
    #     # being served via https.
    #     return true
    #   rescue Curl::Err::ConnectionFailedError
    #     return false
    #   end
    # end

  end
end
