# frozen_string_literal: true
# Specs for all of the PageSpeed code and matchers.
require 'spec_helper'
require 'rspec/webservice_matchers'
require 'web_test/util'


describe RSpec::WebserviceMatchers::BeFast do
  describe '#be_fast' do
    it 'performs a Google PageSpeed Insights API query on a fast site' do
      expect('nonstop.qa').to be_fast
    end

    it 'raises a friendly error if the api key has not been set' do
      # Remove the key
      key = ENV['WEBSERVICE_MATCHER_INSIGHTS_KEY']
      ENV['WEBSERVICE_MATCHER_INSIGHTS_KEY'] = nil

      expect {
        expect('nonstop.qa').not_to be_fast
      }.to raise_error(RuntimeError, /API key/)

      # Replace the key
      ENV['WEBSERVICE_MATCHER_INSIGHTS_KEY'] = key
    end
  end
end
