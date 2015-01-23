require 'spec_helper'
require 'rspec/webservice_matchers'

describe 'be_status' do
  it 'can check 200 for successful resource requests' do
    expect('http://a-page.com/a/page.txt').to be_status 200
  end

  it 'handles domain names as well as URLs' do
    expect('www.website.com').to be_status 200
  end

  it 'accepts status code in text form too' do
    expect('www.website.com').to be_status '200'
  end

  it 'can check for the 503 - Service Unavailable status' do
    expect('http://outoforder.com/').to be_status 503
  end

  it 'can check for 404' do
    expect('http://notfound.com/no.txt').to be_status 404
  end

  it 'gives the actual code received in case of failure' do
    expect {
      expect('http://notfound.com/no.txt').to be_status 200
    }.to fail_matching(/404/)
  end

  it 'succeeds even if the site times out on the first try' do
    expect('http://www.timeout-once.com').to be_status 200
  end
end

describe 'be_up' do
  it 'follows redirects when necessary' do
    expect('perm-redirector.com').to be_up
    expect('temp-redirector.org').to be_up
  end

  it 'can also handle a simple 200' do
    expect('http://www.website.com/').to be_up
  end

  it 'is available via a public API' do
    expect(RSpec::WebserviceMatchers.up?('http://www.website.com/')).to be true
  end

  it 'gives relevant error output' do
    expect {
      expect('http://notfound.com/no.txt').to be_up
    }.to fail_matching(/404/)
  end

  it 'succeeds even if the site times out on the first try' do
    expect('http://www.timeout-once.com').to be_up
  end
end
