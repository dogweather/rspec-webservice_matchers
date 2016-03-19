# frozen_string_literal: true
require 'spec_helper'
require 'rspec/webservice_matchers/util'
include RSpec::WebserviceMatchers

describe '#up?' do
  it 'follows redirects when necessary' do
    expect(Util.up?('perm-redirector.com')).to be_truthy
    expect(Util.up?('temp-redirector.org')).to be_truthy
  end

  it 'retries timeout errors once' do
    expect(Util.up?('http://www.timeout-once.com')).to be_truthy
  end
end
