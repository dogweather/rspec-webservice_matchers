# frozen_string_literal: true
require 'faraday'
require 'webmock/rspec'

RSpec.configure do
  # HOSTS WHICH RETURN ERRORS
  WebMock.stub_request(:any, /notfound.com/).to_return(status: 404)
  WebMock.stub_request(:any, 'outoforder.com').to_return(status: 503)
  WebMock.stub_request(:any, 'not-a-domain.com')
         .to_raise(Faraday::ConnectionFailed.new('Failed to open TCP connection to asdhfjkahsdfadfd.com:80 (getaddrinfo: nodename nor servname provided, or not known)'))


  WebMock.stub_request :any, 'http://a-page.com/a/page.txt'
  WebMock.stub_request :any, 'www.website.com'

  # A host which doesn't support HEAD
  WebMock.stub_request(:head, 'appengine.com').to_return(status: 405)
  WebMock.stub_request(:get,  'appengine.com').to_return(status: 200)

  # WORKING REDIRECTS
  # WebMock.stub_request(:any, 'perm-redirector.com')
  #        .to_return(status: 301, headers: { Location: 'http://www.website.com/' })
  WebMock.stub_request(:head, "http://perm-redirector.com/").
    with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Faraday v0.9.2'}).
    to_return(:status => 301, :body => "", :headers => {Location: 'http://www.website.com/'})

  WebMock.stub_request(:any, 'temp-redirector.org')
         .to_return(status: 302, headers: { Location: 'http://a-page.com/a/page.txt' })

  WebMock.stub_request(:any, 'temp-307-redirector.net')
         .to_return(status: 307, headers: { Location: 'http://a-page.com/a/page.txt' })

  # Timeout scenarios
  WebMock.stub_request(:any, 'www.timeout.com').to_timeout
  WebMock.stub_request(:any, 'www.timeout-once.com').to_timeout.then.to_return(body: 'abc')

  # Insights API
  key = ENV['WEBSERVICE_MATCHER_INSIGHTS_KEY']
  WebMock.stub_request(:get, "https://www.googleapis.com/pagespeedonline/v2/runPagespeed?key=#{key}&screenshot=false&url=http://nonstop.qa")
         .with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent' => 'Faraday v0.9.2' })
         .to_return(
           status: 200,
           body: IO.read('spec/fixtures/pagespeed.json'),
           headers: {})

  # WebMock.allow_net_connect!
end

module RSpec
  # Matchers to help test RSpec matchers
  module Matchers
    def fail
      raise_error(RSpec::Expectations::ExpectationNotMetError)
    end

    def fail_with(message)
      raise_error(RSpec::Expectations::ExpectationNotMetError, message)
    end

    def fail_matching(regex)
      raise_error(RSpec::Expectations::ExpectationNotMetError, regex)
    end
  end
end
