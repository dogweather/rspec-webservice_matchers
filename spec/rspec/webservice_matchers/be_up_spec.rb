# frozen_string_literal: true
require 'spec_helper'
require 'rspec/webservice_matchers/be_up'

describe RSpec::WebserviceMatchers::BeUp::TestResult do
  it { is_expected.to respond_to(:success?) }
end
