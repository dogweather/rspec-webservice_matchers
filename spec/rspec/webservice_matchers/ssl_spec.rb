require 'spec_helper'
require 'rspec/webservice_matchers'

describe 'have_a_valid_cert matcher' do
  it 'passes when SSL is properly configured' do
    # EFF created the HTTPS Everywhere movement
    # TODO: set up a test server for this. (?)
    expect('www.eff.org').to have_a_valid_cert
  end

  it 'fails if the server is not serving SSL at all' do
    expect {
      expect('www.psu.edu').to have_a_valid_cert
    }.to fail
  end

  it 'provides a relevant error message' do
    expect {
      expect('www.psu.edu').to have_a_valid_cert
    }.to fail_matching(/(unreachable)|(no route to host)|(connection refused)/i)
  end

  it "provides a relevant error message when the domain name doesn't exist" do
    expect {
      expect('sdfgkljhsdfghjkhsdfgj.edu').to have_a_valid_cert
    }.to fail_matching(/not known/i)
  end

  it 'provides a good error message if the request times out' do
    expect {
      expect('www.myapp.com').to have_a_valid_cert
    }.to fail_matching(/(timeout)|(execution expired)/)
  end
end

# See https://www.eff.org/https-everywhere
describe 'enforce_https_everywhere' do
  it 'passes when http requests are redirected to valid https urls' do
    expect('eff.org').to enforce_https_everywhere
  end

  it 'provides a relevant error message' do
    expect {
      expect('www.psu.edu').to enforce_https_everywhere
    }.to fail_matching(/200/)
  end

  it "provides a relevant error message when the domain name doesn't exist" do
    expect {
      expect('asdhfjkalsdhfjklasdfhjkasdhfl.com').to enforce_https_everywhere
    }.to fail_matching(/connection failed/i)
  end
end
