require 'rspec/webservice_matchers/version'
require 'faraday'
require 'faraday_middleware'

# Seconds
TIMEOUT = 5 
OPEN_TIMEOUT = 2


module RSpec
  module WebserviceMatchers

    def self.has_valid_ssl_cert?(domain_name_or_url)
      # Normalize the input: remove 'http(s)://' if it's there
      if %r|^https?://(.+)$| === domain_name_or_url
        domain_name_or_url = $1
      end

      # Test by seeing if Curl retrieves without complaining
      begin
        connection.head("https://#{domain_name_or_url}")
        return true
      rescue
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
        response = RSpec::WebserviceMatchers.connection.head(url)
        response.status == 301 && response.headers['location'] == expected
      end
    end

    # Pass successfully if we get a 302 or 307 to the place we intend.
    RSpec::Matchers.define :redirect_temporarily_to do |expected|
      match do |url|
        response = RSpec::WebserviceMatchers.connection.head(RSpec::WebserviceMatchers.make_url(url))
        [302, 307].include?(response.status) && response.headers['location'] == RSpec::WebserviceMatchers.make_url(expected)
      end
    end

    # This is a high level matcher which checks three things:
    # 1. Permanent redirect
    # 2. to an https url
    # 3. which is correctly configured
    RSpec::Matchers.define :enforce_https_everywhere do
      match do |domain_name|
        response = RSpec::WebserviceMatchers.connection.head("http://#{domain_name}")
        new_url  = response.headers['location']
        (response.status == 301) && (/https/ === new_url) && (RSpec::WebserviceMatchers.has_valid_ssl_cert?(new_url))
      end
    end

    # Pass when a URL returns the expected status code
    # Codes are defined in http://www.rfc-editor.org/rfc/rfc2616.txt
    RSpec::Matchers.define :be_status do |expected|
      match do |url_or_domain_name|
        url      = RSpec::WebserviceMatchers.make_url(url_or_domain_name)
        response = RSpec::WebserviceMatchers.connection.head(url)
        response.status == expected.to_i
      end
    end

    # Pass when the response code is 200, following redirects
    # if necessary.
    RSpec::Matchers.define :be_up do
      match do |url_or_domain_name|
        url  = RSpec::WebserviceMatchers.make_url(url_or_domain_name)
        conn = Faraday.new do |c|
          c.options[:timeout] = TIMEOUT
          c.options[:open_timeout] = TIMEOUT
          c.use FaradayMiddleware::FollowRedirects, limit: 5
          c.adapter :net_http
        end
        response = conn.head(url)
        response.status == 200
      end
    end


    private

    def self.connection
      Faraday.new do |c|
        c.options[:timeout] = TIMEOUT
        c.options[:open_timeout] = TIMEOUT
        c.adapter :net_http
      end      
    end

    # Ensure that the given string is a URL,
    # making it into one if necessary.
    def self.make_url(url_or_domain_name)
      unless %r|^https?://| === url_or_domain_name
        "http://#{url_or_domain_name}"
      else
        url_or_domain_name
      end
    end

  end
end
