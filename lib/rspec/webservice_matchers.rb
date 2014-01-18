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
        result  = Curl::Easy.http_head(url)
        headers = RSpec::WebserviceMatchers.parse_response_headers(result)
        result.response_code == 301 && headers['Location'] == expected
      end
    end    

    # Pass successfully if we get a 302 or 307 to the place we intend.
    RSpec::Matchers.define :redirect_temporarily_to do |expected|
      match do |url|
        result  = Curl::Easy.http_head(url)
        headers = RSpec::WebserviceMatchers.parse_response_headers(result)
        [302, 307].include?(result.response_code) && headers['Location'] == expected
      end
    end    

    # This is a high level matcher which checks three things:
    # 1. Permanent redirect
    # 2. to an https url
    # 3. which is correctly configured
    RSpec::Matchers.define :enforce_https_everywhere do
      match do |domain_name|
        result  = Curl::Easy.http_head("http://#{domain_name}")
        headers = RSpec::WebserviceMatchers.parse_response_headers(result)
        new_url = headers['Location']
        (result.response_code == 301) && (/https/ === new_url) && (RSpec::WebserviceMatchers.has_valid_ssl_cert?(new_url))
      end
    end   

    # Pass when a URL returns the expected status code
    # Codes are defined in http://www.rfc-editor.org/rfc/rfc2616.txt
    RSpec::Matchers.define :be_status do |expected|
      match do |url_or_domain_name|
        url    = RSpec::WebserviceMatchers.make_url(url_or_domain_name)
        result = Curl::Easy.http_head(url)
        (result.response_code == expected.to_i)
      end
    end


    private

    # Ensure that the given string is a URL,
    # making it into one if necessary.
    def self.make_url(url_or_domain_name)
      unless %r|^https?://| === url_or_domain_name
        "http://#{url_or_domain_name}"
      else
        url_or_domain_name
      end
    end


    # Return a hash of response headers from the
    # given curl result.
    # TODO: Submit as a pull request to the Curb gem.
    def self.parse_response_headers(curl_result)
      header_lines = curl_result.head.split("\r\n")
      header_lines.delete_at(0) # The first reponse header is in another format and already parsed.
      response_headers = {}
      header_lines.each do |line|
        key, value = line.split(': ')
        response_headers[key] = value
      end
      return response_headers
    end

  end
end
