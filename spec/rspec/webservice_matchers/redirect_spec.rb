require 'spec_helper'
require 'rspec/webservice_matchers'


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

  it 'gives a good error message for the wrong redirect type' do
    expect {
      expect('temp-redirector.org').to redirect_permanently_to('www.website.com')
    }.to fail_matching(/temporary/i)
  end
end


describe 'redirect_temporarily_to' do
  it 'passes when it gets a 302' do
    'http://temp-redirector.org'.should redirect_temporarily_to 'http://a-page.com/a/page.txt'
  end

  it 'handles domain names gracefully' do
    'temp-redirector.org'.should redirect_temporarily_to 'a-page.com/a/page.txt'
  end 

  it 'passes when it gets a 307' do
    'temp-307-redirector.net'.should redirect_temporarily_to 'a-page.com/a/page.txt'
  end
end