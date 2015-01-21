require 'spec_helper'
require 'rspec/webservice_matchers'

describe '#up?' do
  it 'follows redirects when necessary' do
    expect(RSpec::WebserviceMatchers.up?('perm-redirector.com')).to be_truthy
    expect(RSpec::WebserviceMatchers.up?('temp-redirector.org')).to be_truthy
  end

  it 'retries timeout errors once' do
    expect(RSpec::WebserviceMatchers.up?('http://www.timeout-once.com')).to be_truthy
  end
end
