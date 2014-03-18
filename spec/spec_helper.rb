require 'webmock/rspec'

RSpec.configure do |config|
  config.before(:each) do

    WebMock.stub_request :any, 'http://a-page.com/a/page.txt'
    WebMock.stub_request :any, 'www.website.com'
    WebMock.stub_request(:any, /notfound.com/).to_return(status: 404)
    WebMock.stub_request(:any, 'outoforder.com').to_return(status: 503)

    WebMock.stub_request(:any, 'perm-redirector.com')
      .to_return(status: 301, headers: {Location: 'http://www.website.com/'})

    WebMock.allow_net_connect!
  end
end
