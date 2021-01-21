# frozen_string_literal: true
require 'faraday'
require 'faraday_middleware'

TIMEOUT_IN_SECONDS      = 5
OPEN_TIMEOUT_IN_SECONDS = 5

module WebTest
  module Util
    def self.error_message(errors)
      return errors.message if errors.respond_to?(:message)

      errors
        .map(&:to_s)
        .join('; ')
        .capitalize
    end

    def self.status(url_or_domain_name, follow: false)
      code = head(url_or_domain_name, follow: follow)[0]
      return code if code != 405
      get(url_or_domain_name, follow: follow)[0]
    end

    def self.head(url_or_domain_name, follow: false)
      request(:head, url_or_domain_name, follow: follow)
    end

    def self.get(url_or_domain_name, follow: false)
      request(:get, url_or_domain_name, follow: follow)
    end

    def self.request(method, url_or_domain_name, follow: false)
      url = make_url(url_or_domain_name)
      response = recheck_on_timeout { connection(follow: follow).send(method, url) }
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

    def self.valid_cert?(domain_name_or_url)
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

    # private

    def self.connection(follow: false)
      Faraday.new do |c|
        c.options[:timeout] = TIMEOUT_IN_SECONDS
        c.options[:open_timeout] = OPEN_TIMEOUT_IN_SECONDS
        c.use(FaradayMiddleware::FollowRedirects, limit: 4) if follow
        c.adapter :net_http
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

    # Return just the domain name portion of a URL if 
    # it's simply of the form http://name.tld
    def self.make_domain_name(url_or_domain_name)
      if %r{^https?://(.+)} =~ url_or_domain_name
        $1
      else
        url_or_domain_name
      end
    end

    # Normalize the input: remove 'http(s)://' if it's there
    def self.remove_protocol(domain_name_or_url)
      %r{^https?://(?<name>.+)$} =~ domain_name_or_url
      name || domain_name_or_url
    end

    def self.recheck_on_timeout
      yield
    rescue Faraday::TimeoutError
      yield
    end
  end
end
