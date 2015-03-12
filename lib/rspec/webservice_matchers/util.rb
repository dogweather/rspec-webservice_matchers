require 'excon'
require 'faraday'
require 'faraday_middleware'
require 'pry'

# Seconds
TIMEOUT = 20
OPEN_TIMEOUT = 20

module RSpec
  module WebserviceMatchers
    # Refactored utility functions
    module Util
      def self.status(url_or_domain_name, follow: false)
        head(url_or_domain_name, follow: follow)[0]
      end

      def self.head(url_or_domain_name, follow: false)
        url = make_url(url_or_domain_name)
        response = recheck_on_timeout { connection(follow: follow).head(url) }
        [response.status, response.headers]
      end

      # @return true if the given page has status 200,
      # and follow a few redirects if necessary.
      def self.up?(url_or_domain_name)
        url  = make_url(url_or_domain_name)
        conn = connection(follow: true)
        response = recheck_on_timeout { conn.head(url) }
        response.status == 200
      end

      def self.valid_ssl_cert?(domain_name_or_url)
        try_ssl_connection(domain_name_or_url)
        true
      rescue
        # Not serving SSL, expired, or incorrect domain name in certificate
        false
      end

      def self.try_ssl_connection(domain_name_or_url)
        url = "https://#{remove_protocol(domain_name_or_url)}"
        recheck_on_timeout { connection.head(url) }
        true
      end

      private

      def self.connection(follow: false)
        Faraday.new do |c|
          c.options[:timeout] = TIMEOUT
          c.options[:open_timeout] = OPEN_TIMEOUT
          c.use(FaradayMiddleware::FollowRedirects, limit: 4) if follow
          c.adapter :excon
        end
      end

      # Ensure that the given string is a URL,
      # making it into one if necessary.
      def self.make_url(url_or_domain_name)
        if %r{^https?://} =~ url_or_domain_name
          url_or_domain_name
        else
          "http://#{url_or_domain_name}"
        end
      end

      # Normalize the input: remove 'http(s)://' if it's there
      def self.remove_protocol(domain_name_or_url)
        %r{^https?://(?<name>.+)$} =~ domain_name_or_url
        name || domain_name_or_url
      end

      def self.recheck_on_timeout
        begin
          yield
        rescue Faraday::Error::TimeoutError
          yield
        end
      end
    end
  end
end
