# frozen_string_literal: true
require 'spec_helper'
require 'rspec/webservice_matchers/be_fast'
include RSpec::WebserviceMatchers

describe BeFast do
  describe BeFast::TestResult do
    it 'requires :success' do
      expect {
        BeFast::TestResult.new {}
      }.to raise_error(ArgumentError, /success/i)
    end

    it 'requires :score' do
      expect {
        BeFast::TestResult.new { |r| r.success = true }
      }.to raise_error(ArgumentError, /score/i)
    end
  end

  describe '#test' do
    it 'handles a fast site' do
      result = RSpec::WebserviceMatchers::BeFast.test url: 'http://nonstop.qa'
      expect( result.success?    ).to be true
      expect( result.status_code ).to be_gt(84)
    end
  end
end
