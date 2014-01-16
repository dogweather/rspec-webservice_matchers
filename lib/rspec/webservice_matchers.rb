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

    # Would this function be helpful?

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


    # RSpec Custom Matchers ###########################################
    # See https://www.relishapp.com/rspec/rspec-expectations/v/3-0/docs/custom-matchers/define-matcher
    

    RSpec::Matchers.define :have_a_valid_cert do
      match do |domain_name|
        RSpec::WebserviceMatchers.has_valid_ssl_cert?(domain_name)
      end
    end

    RSpec::Matchers.define :redirect_permanently_to do |expected|
      match do |url|
        # TODO: Refactor this code. Submit as pull request to Curb.
        result = Curl::Easy.http_head(url)
        header_lines = result.head.split("\r\n")
        header_lines.delete_at(0) # The first reponse header is already parsed.
        header = {}
        header_lines.each do |line|
          key, value = line.split(': ')
          header[key] = value
        end         
        result.response_code == 301 && header['Location'] == expected
      end
    end    

    RSpec::Matchers.define :enforce_https_everywhere do
      match do |domain_name|
        # TODO: Refactor this code. Submit as pull request to Curb.
        result = Curl::Easy.http_head("http://#{domain_name}")
        header_lines = result.head.split("\r\n")
        header_lines.delete_at(0) # The first reponse header is already parsed.
        header = {}
        header_lines.each do |line|
          key, value = line.split(': ')
          header[key] = value
        end
        (result.response_code == 301) && (/https/ === header['Location'])
      end
    end    

  end
end
