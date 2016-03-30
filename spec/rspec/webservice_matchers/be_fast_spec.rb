# frozen_string_literal: true
require 'spec_helper'
require 'rspec/webservice_matchers/be_fast'
include RSpec::WebserviceMatchers::BeFast

describe RSpec::WebserviceMatchers::BeFast do

  describe TestResult do
    it 'requires :success' do
      expect {
        TestResult.new {}
      }.to raise_error(ArgumentError, /success/i)
    end

    it 'requires :score' do
      expect {
        TestResult.new { |r| r.success = true }
      }.to raise_error(ArgumentError, /score/i)
    end
  end

  # describe '#test' do
  #   it 'handles a simple 200' do
  #     result = BeUp.test url: 'http://www.website.com/'
  #     expect( result.success?    ).to be true
  #     expect( result.status_code ).to be 200
  #   end
  #
  #   it 'handles a simple 200 as a domain' do
  #     result = BeUp.test domain: 'www.website.com'
  #     expect( result.success?    ).to be true
  #     expect( result.status_code ).to be 200
  #   end
  #
  #   it 'handles a 404' do
  #     result = BeUp.test url: 'http://notfound.com/no.txt'
  #     expect( result.success?    ).to be false
  #     expect( result.status_code ).to be 404
  #   end
  # end
end
