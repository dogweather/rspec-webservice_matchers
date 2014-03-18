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


    # Return true if the given page has status 200,
    # and follow a few redirects if necessary.
    def self.up?(url_or_domain_name)
      url  = RSpec::WebserviceMatchers.make_url(url_or_domain_name)
      conn = RSpec::WebserviceMatchers.connection(follow: true)
      response = conn.head(url)
      response.status == 200
    end


    def self.try_ssl_connection(domain_name_or_url)
      # Normalize the input: remove 'http(s)://' if it's there
      if %r|^https?://(.+)$| === domain_name_or_url
        domain_name_or_url = $1
      end
      connection.head("https://#{domain_name_or_url}")
    end


    # RSpec Custom Matchers ###########################################
    # See https://www.relishapp.com/rspec/rspec-expectations/v/2-3/docs/custom-matchers/define-matcher

    # Test whether https is correctly implemented
    RSpec::Matchers.define :have_a_valid_cert do
      error_message = nil

      match do |domain_name_or_url|
        begin
          RSpec::WebserviceMatchers.try_ssl_connection(domain_name_or_url)
          true
        rescue Exception => e
          error_message = e.message
          false
        end
      end

      failure_message_for_should do
        error_message
      end
    end


    # Pass successfully if we get a 301 to the place we intend.
    RSpec::Matchers.define :redirect_permanently_to do |expected|
      error_message = actual_status = actual_location = nil

      match do |url_or_domain_name|
        begin
          response = RSpec::WebserviceMatchers.connection.head(RSpec::WebserviceMatchers.make_url url_or_domain_name)
          expected = RSpec::WebserviceMatchers.make_url(expected)
          actual_location = response.headers['location']
          actual_status   = response.status

          (actual_status == 301) && (%r|#{expected}/?| === actual_location)
        rescue Exception => e
          error_message = e.message
          false  
        end
      end

      failure_message_for_should do
        if ! error_message.nil?
          error_message
        else
          mesgs = []
          if [302, 307].include? actual_status
            mesgs << "received a temporary redirect, status #{actual_status}"
          end
          if ! actual_location.nil? && ! (%r|#{expected}/?| === actual_location)
            mesgs << "location was given as #{actual_location}"
          end
          if ! [301, 302, 307].include? actual_status
            mesgs << "not a redirect: received status #{actual_status}"
          end
          mesgs.join('; ').capitalize
        end
      end
    end


    # Pass successfully if we get a 302 or 307 to the place we intend.
    RSpec::Matchers.define :redirect_temporarily_to do |expected|
      error_message = actual_status = actual_location = nil

      match do |url_or_domain_name|
        begin
          response = RSpec::WebserviceMatchers.connection.head(RSpec::WebserviceMatchers.make_url url_or_domain_name)
          expected = RSpec::WebserviceMatchers.make_url(expected)
          actual_location = response.headers['location']
          actual_status   = response.status

          [302, 307].include?(actual_status) && (%r|#{expected}/?| === actual_location)
        rescue Exception => e
          error_message = e.message
          false  
        end
      end

      failure_message_for_should do
        if ! error_message.nil?
          error_message
        else
          mesgs = []
          if actual_status == 301
            mesgs << "received a permanent redirect, status #{actual_status}"
          end
          if ! actual_location.nil? && ! (%r|#{expected}/?| === actual_location)
            mesgs << "location was given as #{actual_location}"
          end
          if ! [301, 302, 307].include? actual_status
            mesgs << "not a redirect: received status #{actual_status}"
          end
          mesgs.join('; ').capitalize
        end
      end
    end


    # This is a high level matcher which checks three things:
    # 1. Permanent redirect
    # 2. to an https url
    # 3. which is correctly configured
    RSpec::Matchers.define :enforce_https_everywhere do
      error_msg = actual_status = actual_protocol = actual_valid_cert = nil

      match do |domain_name|
        begin
          response = RSpec::WebserviceMatchers.connection.head("http://#{domain_name}")
          new_url  = response.headers['location']
          actual_status  = response.status
          if new_url =~ /^(https?)/
            actual_protocol = $1
          end
          actual_valid_cert = RSpec::WebserviceMatchers.has_valid_ssl_cert?(new_url)
          (actual_status == 301) &&
            (actual_protocol == 'https') &&
            (actual_valid_cert == true)
        rescue Faraday::Error::ConnectionFailed => e
          error_msg = "Connection failed"
          false
        end
      end

      # Create a compound error message listing all of the
      # relevant actual values received.
      failure_message_for_should do
        if !error_msg.nil?
          error_msg
        else
          mesgs = []
          if actual_status != 301
            mesgs << "received status #{actual_status} instead of 301"
          end
          if !actual_protocol.nil? && actual_protocol != 'https'
            mesgs << "destination uses protocol #{actual_protocol.upcase}"
          end
          if ! actual_valid_cert
            mesgs << "there's no valid SSL certificate"
          end
          mesgs.join('; ').capitalize
        end
      end

    end


    # Pass when a URL returns the expected status code
    # Codes are defined in http://www.rfc-editor.org/rfc/rfc2616.txt
    RSpec::Matchers.define :be_status do |expected|
      actual_code = nil
      
      match do |url_or_domain_name|
        url         = RSpec::WebserviceMatchers.make_url(url_or_domain_name)
        response    = RSpec::WebserviceMatchers.connection.head(url)
        actual_code = response.status
        expected    = expected.to_i
        actual_code == expected
      end

      failure_message_for_should do
        "Received status #{actual_code}"
      end
    end


    # Pass when the response code is 200, following redirects
    # if necessary.
    RSpec::Matchers.define :be_up do
      actual_status = nil

      match do |url_or_domain_name|
        url  = RSpec::WebserviceMatchers.make_url(url_or_domain_name)
        conn = RSpec::WebserviceMatchers.connection(follow: true)
        response = conn.head(url)
        actual_status = response.status
        actual_status == 200
      end

      failure_message_for_should do
        "Received status #{actual_status}"
      end
    end


    private

    def self.connection(follow: false)
      Faraday.new do |c|
        c.options[:timeout] = TIMEOUT
        c.options[:open_timeout] = TIMEOUT
        if follow
          c.use FaradayMiddleware::FollowRedirects, limit: 4          
        end
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
