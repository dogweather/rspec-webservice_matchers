# frozen_string_literal: true
require 'spec_helper'
require 'web_test/util'

include RSpec::WebserviceMatchers

describe '#up?' do
  it 'follows redirects when necessary' do
    expect(WebTest::Util.up?('perm-redirector.com')).to be_truthy
    expect(WebTest::Util.up?('temp-redirector.org')).to be_truthy
  end

  it 'retries timeout errors once' do
    expect(WebTest::Util.up?('http://www.timeout-once.com')).to be_truthy
  end
end
