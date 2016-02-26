# Specs for all of the PageSpeed code and matchers.

require 'spec_helper'
require 'rspec/webservice_matchers'
require 'rspec/webservice_matchers/util'

describe 'be_fast' do
  it 'is in a module which is loaded' do
    expect(RSpec::WebserviceMatchers::BeFast).not_to be_nil
  end
end
