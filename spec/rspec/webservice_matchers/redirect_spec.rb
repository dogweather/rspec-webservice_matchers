require 'spec_helper'
require 'rspec/webservice_matchers'

#
# TODO: Set up a server for these. (Or a mock?) 
#       Faraday supports testing: we can use that now.
#

describe 'redirect_permanently_to' do
  it 'passes when receiving a 301 to the given URL' do
    expect('http://perm-redirector.com').to redirect_permanently_to('http://www.website.com/')
  end

  it 'handles domain names gracefully' do
    expect('perm-redirector.com').to redirect_permanently_to('www.website.com/')
  end

  it 'handles missing final slash' do
    expect('perm-redirector.com').to redirect_permanently_to('www.website.com')
  end 
end


describe 'redirect_temporarily_to' do
  it 'passes when it gets a 302' do
    'http://temp-redirector.org'.should redirect_temporarily_to 'http://a-page.com/a/page.txt'
  end

  # TODO: Set up the mock server and test these
  it 'handles domain names gracefully'
  it 'passes when it gets a 307'
end