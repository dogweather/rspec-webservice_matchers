# frozen_string_literal: true

require 'spec_helper'
require 'rspec/webservice_matchers'

describe 'SSL tests' do
  before(:each) { WebMock.allow_net_connect! }
  after(:each)  { WebMock.disable_net_connect! }

  describe 'have_a_valid_cert matcher' do
    it 'passes when SSL is properly configured' do
      # EFF created the HTTPS Everywhere movement
      # TODO: set up a test server for this. (?)
      expect('www.eff.org').to have_a_valid_cert
    end

    it 'fails if the server is not serving SSL at all' do
      expect do
        expect('neverssl.com').to have_a_valid_cert
      end.to fail_matching(/Unable to verify/)
    end

    it 'provides a relevant error message' do
      expect do
        expect('neverssl.com').to have_a_valid_cert
      end.to fail_matching(/(unreachable)|(no route to host)|(connection refused)/i)
    end

    # it "provides a relevant error message when the domain name doesn't exist" do
    #   expect do
    #     expect('sdfgkljhsdfghjkhsdfgj.edu').to have_a_valid_cert
    #   end.to fail_matching(/not known/i)
    # end

    # it "provides a good error message when it's a redirect" do
    #   expect do
    #     # Can't figure out how to do this with WebMock.
    #     expect('bloc.io').to have_a_valid_cert
    #   end.to fail_matching(/redirect/i)
    # end

    # TODO: Find a good way to test this.
    # it 'provides a good error message if the request times out' do
    #   expect {
    #     expect('www.myapp.com').to have_a_valid_cert
    #   }.to fail_matching(/(timeout)|(execution expired)/)
    # end
  end

  # See https://www.eff.org/https-everywhere
  describe 'enforce_https_everywhere' do
    it 'passes when http requests are redirected to valid https urls' do
      expect('www.eff.org').to enforce_https_everywhere
    end

    it 'passes when given an https url' do
      expect('https://www.eff.org').to enforce_https_everywhere
    end

    it 'passes when given an http url' do
      expect('http://www.eff.org').to enforce_https_everywhere
    end

    it 'provides a relevant error code' do
      expect do
        expect('neverssl.com').to enforce_https_everywhere
      end.to fail_matching(/200/)
    end

    it 'provides a relevant error code with https url' do
      expect do
        expect('https://neverssl.com').to enforce_https_everywhere
      end.to fail_matching(/200/)
    end

    it 'provides a relevant error code with http url' do
      expect do
        expect('http://neverssl.com').to enforce_https_everywhere
      end.to fail_matching(/200/)
    end
    # it "provides a relevant error message when the domain name doesn't exist" do
    #   expect do
    #     expect('asdhfjkalsdhfjklasdfhjkasdhfl.com').to enforce_https_everywhere
    #   end.to fail_matching(/connection failed/i)
    # end
  end
end
