# frozen_string_literal: true
require 'spec_helper'
require 'web_test/be_fast'

RSpec.describe WebTest::BeFast do
  it { is_expected.not_to be_nil }

  describe '#test' do
    it 'handles a fast site' do
      result = WebTest::BeFast.test url: 'https://constant.qa'
      expect(result.success?).to be true
      expect(result.score).to be >= 85
    end
  end

  describe '#parse' do
    it 'can parse the overall score' do
      api_response = File.read(SAMPLE_PAGESPEED_JSON_RESPONSE)
      data = WebTest::BeFast.parse json: api_response
      expect(data[:score]).to eq 85
    end
  end

  describe WebTest::BeFast::TestResult do
    it 'requires :success' do
      expect do
        WebTest::BeFast::TestResult.new {}
      end.to raise_error(ArgumentError, /success/i)
    end

    it 'requires :score' do
      expect do
        WebTest::BeFast::TestResult.new { |r| r.success = true }
      end.to raise_error(ArgumentError, /score/i)
    end

    it 'requires :response' do
      expect do
        WebTest::BeFast::TestResult.new { |r|
          r.success = true
          r.score = 90
        }
      end.to raise_error(ArgumentError, /response/i)      
    end
  end
end
