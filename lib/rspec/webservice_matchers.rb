require 'rspec/webservice_matchers/version'
require 'curb'

module RSpec
  module WebserviceMatchers

    def self.has_valid_ssl_cert?(domain_name_or_url)
      # Normalize the input: remove 'http(s)://' if it's there
      if %r|^https?://(.+)$| === domain_name_or_url
        domain_name_or_url = $1
      end

      # Test by seeing if Curl retrieves without complaining
      begin
        Curl::Easy.http_head "https://#{domain_name_or_url}"
        return true
      rescue Curl::Err::ConnectionFailedError, Curl::Err::SSLCACertificateError, Curl::Err::SSLPeerCertificateError
        # Not serving SSL, expired, or incorrect domain name in certificate
        return false
      end
    end


    # RSpec Custom Matchers ###########################################
    # See https://www.relishapp.com/rspec/rspec-expectations/v/2-3/docs/custom-matchers/define-matcher

    # Test whether https is correctly implemented
    RSpec::Matchers.define :have_a_valid_cert do
      match do |domain_name_or_url|
        RSpec::WebserviceMatchers.has_valid_ssl_cert?(domain_name_or_url)
      end
    end

    # Pass successfully if we get a 301 to the place we intend.
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

    # This is a high level matcher which checks three things:
    # 1. Permanent redirect
    # 2. to an https url
    # 3. which is correctly configured
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
        (result.response_code == 301) && (/https/ === header['Location']) && (RSpec::WebserviceMatchers.has_valid_ssl_cert?(header['Location']))
      end
    end    

  end
end
