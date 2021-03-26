# frozen_string_literal: true
require 'faraday'
require 'webmock/rspec'

RSpec.configure do |config|
  config.before(:each) do
    # HOSTS WHICH RETURN ERRORS
    WebMock.stub_request(:any, /notfound.com/).to_return(status: 404)
    WebMock.stub_request(:any, 'outoforder.com').to_return(status: 503)
    WebMock.stub_request(:any, 'not-a-domain.com')
           .to_raise(Faraday::ConnectionFailed.new('Failed to open TCP ' \
                     'connection to asdhfjkahsdfadfd.com:80 ' \
                     '(getaddrinfo: nodename nor servname provided, ' \
                     'or not known)'))

    # FUNCTIONING WEB PAGES
    WebMock.stub_request :any, 'http://a-page.com/a/page.txt'
    WebMock.stub_request :any, 'www.website.com'

    # A HOST WHICH DOESN'T SUPPORT HEAD
    WebMock.stub_request(:head, 'appengine.com').to_return(status: 405)
    WebMock.stub_request(:get,  'appengine.com').to_return(status: 200)

    # FUNCTIONING REDIRECTS
    WebMock.stub_request(:head, 'perm-redirector.com')
           .to_return(status: 301,
                      body: '',
                      headers: { Location: 'http://www.website.com/' })

    WebMock.stub_request(:any, 'temp-redirector.org')
           .to_return(status: 302,
                      headers: { Location: 'http://a-page.com/a/page.txt' })

    WebMock.stub_request(:any, 'temp-307-redirector.net')
           .to_return(status: 307,
                      headers: { Location: 'http://a-page.com/a/page.txt' })

    # TIMEOUT SCENARIOS
    WebMock.stub_request(:any, 'www.timeout.com').to_timeout
    WebMock.stub_request(:any, 'www.timeout-once.com').to_timeout
           .then.to_return(body: 'abc')

    # PageSpeed Insights API
    key = ENV['WEBSERVICE_MATCHER_INSIGHTS_KEY']
    WebMock.stub_request(:get,
                         'https://www.googleapis.com/pagespeedonline/v5/' \
                         "runPagespeed?key=#{key}&screenshot=false" \
                         '&url=https://constant.qa')
           .to_return(
             status: 200,
             body: IO.read('spec/fixtures/pagespeed.json'),
             headers: {})
  end
end
