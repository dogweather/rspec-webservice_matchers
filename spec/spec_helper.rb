require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require 'webmock/rspec'

RSpec.configure do |config|
  config.before(:each) do
    WebMock.stub_request :any, 'http://a-page.com/a/page.txt'
    WebMock.stub_request :any, 'www.website.com'
    WebMock.stub_request(:any, /notfound.com/).to_return(status: 404)
    WebMock.stub_request(:any, 'outoforder.com').to_return(status: 503)

    WebMock.stub_request(:any, 'perm-redirector.com')
      .to_return(status: 301, headers: { Location: 'http://www.website.com/' })

    WebMock.stub_request(:any, 'temp-redirector.org')
      .to_return(status: 302, headers: { Location: 'http://a-page.com/a/page.txt' })

    WebMock.stub_request(:any, 'temp-307-redirector.net')
      .to_return(status: 307, headers: { Location: 'http://a-page.com/a/page.txt' })

    # Timeout scenarios
    WebMock.stub_request(:any, 'www.timeout.com').to_timeout
    WebMock.stub_request(:any, 'www.timeout-once.com').to_timeout.then.to_return({body: 'abc'})

    WebMock.allow_net_connect!
  end
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
