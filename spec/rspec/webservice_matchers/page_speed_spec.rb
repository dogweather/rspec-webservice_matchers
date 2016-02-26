# Specs for all of the PageSpeed code and matchers.

require 'spec_helper'
require 'rspec/webservice_matchers'
require 'rspec/webservice_matchers/util'

SAMPLE_JSON_RESPONSE = 'spec/fixtures/pagespeed.json'

describe RSpec::WebserviceMatchers::BeFast do
  describe '#parse' do
    it 'can parse the overall score' do
      api_response = File.read(SAMPLE_JSON_RESPONSE)
      data = RSpec::WebserviceMatchers::BeFast.parse(json: api_response)
      expect(data[:score]).to eq(85)
    end
  end

  describe '#be_fast' do
    it 'performs a Google PageSpeed Insights API query on a slow site' do
      expect('nonstop.qa').not_to be_fast
    end
  end
end
