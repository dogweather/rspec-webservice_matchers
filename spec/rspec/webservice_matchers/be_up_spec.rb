# frozen_string_literal: true
require 'spec_helper'
require 'rspec/webservice_matchers/be_up'

describe RSpec::WebserviceMatchers::BeUp::TestResult do
  it { should respond_to(:success?) }
end
