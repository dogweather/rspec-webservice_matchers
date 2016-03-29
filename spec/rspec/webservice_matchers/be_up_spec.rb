# frozen_string_literal: true
require 'spec_helper'
require 'rspec/webservice_matchers/be_up'

describe RSpec::WebserviceMatchers::BeUp::TestResult do
  it { is_expected.to respond_to(:success?) }
  it { is_expected.to respond_to(:status_code) }

  it 'Success is a required attrib.' do
    expect {
      RSpec::WebserviceMatchers::BeUp::TestResult.new { |r| r.status_code = 200 }
    }.to raise_error(ArgumentError)
  end
end
