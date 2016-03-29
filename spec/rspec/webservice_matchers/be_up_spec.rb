# frozen_string_literal: true
require 'spec_helper'
require 'rspec/webservice_matchers/be_up'

include RSpec::WebserviceMatchers::BeUp


describe '#test' do
  it 'handles a simple 200' do
    result = BeUp.test(url: 'http://www.website.com/')
    expect( result.success?    ).to be true
    expect( result.status_code ).to be 200
  end
end


describe TestResult do
  it 'requires :success' do
    expect {
      TestResult.new { |r| r.status_code = 200 }
    }.to raise_error(ArgumentError)
  end

  it 'requires :status_code' do
    expect {
      TestResult.new { |r| r.success = true }
    }.to raise_error(ArgumentError)
  end

  it 'accepts boolean :success & integer :status_code' do
    result = TestResult.new do |r|
      r.status_code = 404
      r.success = false
    end
    expect( result ).to be_an_instance_of(TestResult)
  end

  it 'requires boolean :success' do
    expect {
      TestResult.new do |r|
        r.status_code = 200
        r.success = 1
      end
    }.to raise_error(ArgumentError)
  end

  it 'requires integer :status_code' do
    expect {
      TestResult.new do |r|
        r.status_code = '404'
        r.success = false
      end
    }.to raise_error(ArgumentError)
  end

  it 'cannot have status < 100' do
    expect {
      TestResult.new do |r|
        r.status_code = -5
        r.success = false
      end
    }.to raise_error(ArgumentError)
  end

  it 'cannot have status > 510' do
    expect {
      TestResult.new do |r|
        r.status_code = 511
        r.success = false
      end
    }.to raise_error(ArgumentError)
  end

  it 'allows status 510' do
    result = TestResult.new do |r|
      r.status_code = 510
      r.success = false
    end
    expect( result ).to be_an_instance_of(TestResult)
  end
end
