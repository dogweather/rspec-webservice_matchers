# frozen_string_literal: true
require 'spec_helper'
require 'web_test/be_up'


describe WebTest::BeUp do
  describe '#test' do
    it 'handles a simple 200' do
      result = WebTest::BeUp.test url: 'http://www.website.com/'
      expect( result.success?    ).to be true
      expect( result.status_code ).to be 200
    end

    it 'handles a simple 200 as a domain' do
      result = WebTest::BeUp.test domain: 'www.website.com'
      expect( result.success?    ).to be true
      expect( result.status_code ).to be 200
    end

    it 'handles a 404' do
      result = WebTest::BeUp.test url: 'http://notfound.com/no.txt'
      expect( result.success?    ).to be false
      expect( result.status_code ).to be 404
    end
  end


  describe WebTest::BeUp::TestResult do
    it 'requires :success' do
      expect {
        WebTest::BeUp::TestResult.new { |r| r.status_code = 200 }
      }.to raise_error(ArgumentError)
    end

    it 'requires :status_code' do
      expect {
        WebTest::BeUp::TestResult.new { |r| r.success = true }
      }.to raise_error(ArgumentError)
    end

    it 'accepts boolean :success & integer :status_code' do
      result = WebTest::BeUp::TestResult.new do |r|
        r.status_code = 404
        r.success = false
      end
      expect( result ).to be_an_instance_of(WebTest::BeUp::TestResult)
    end

    it 'requires boolean :success' do
      expect {
        WebTest::BeUp::TestResult.new do |r|
          r.status_code = 200
          r.success = 1
        end
      }.to raise_error(ArgumentError)
    end

    it 'requires integer :status_code' do
      expect {
        WebTest::BeUp::TestResult.new do |r|
          r.status_code = '404'
          r.success = false
        end
      }.to raise_error(ArgumentError)
    end

    it 'cannot have status < 100' do
      expect {
        WebTest::BeUp::TestResult.new do |r|
          r.status_code = -5
          r.success = false
        end
      }.to raise_error(ArgumentError)
    end

    it 'cannot have status > 510' do
      expect {
        WebTest::BeUp::TestResult.new do |r|
          r.status_code = 511
          r.success = false
        end
      }.to raise_error(ArgumentError)
    end

    it 'allows status 510' do
      result = WebTest::BeUp::TestResult.new do |r|
        r.status_code = 510
        r.success = false
      end
      expect( result ).to be_an_instance_of(WebTest::BeUp::TestResult)
    end
  end
end
