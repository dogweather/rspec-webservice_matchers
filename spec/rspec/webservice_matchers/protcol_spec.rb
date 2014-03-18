require 'spec_helper'
require 'rspec/webservice_matchers'


describe 'be_status' do
  it 'can check 200 for successful resource requests' do
    'http://a-page.com/a/page.txt'.should be_status 200
  end

  it 'handles domain names as well as URLs' do
    'www.website.com'.should be_status 200
  end

  it 'accepts status code in text form too' do
    'www.website.com'.should be_status '200'
  end

  it 'can check for the 503 - Service Unavailable status' do
    'http://outoforder.com/'.should be_status 503
  end

  it 'can check for 404' do
    expect('http://notfound.com/no.txt').to be_status 404
  end

  it 'gives the actual code received in case of failure' do
    expect {
      expect('http://notfound.com/no.txt').to be_status 200
    }.to fail_matching(/404/)
  end
end


describe 'be_up' do
  it 'follows redirects when necessary' do
    'perm-redirector.com'.should be_up
  end

  it 'can also handle a simple 200' do
    'http://www.website.com/'.should be_up
  end

  it 'is available via a public API' do
    RSpec::WebserviceMatchers.up?('http://www.website.com/').should be true
  end
end
