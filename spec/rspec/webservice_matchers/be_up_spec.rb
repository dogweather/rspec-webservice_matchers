# frozen_string_literal: true
require 'spec_helper'
require 'rspec/webservice_matchers/be_up'

include RSpec::WebserviceMatchers::BeUp

describe TestResult do
  it 'Success is a required attrib.' do
    expect {
      TestResult.new { |r| r.status_code = 200 }
    }.to raise_error(ArgumentError)
  end
end
