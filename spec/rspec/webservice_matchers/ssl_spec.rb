require 'rspec/webservice_matchers'

describe 'have_a_valid_cert matcher' do
  it 'passes when SSL is properly configured' do
    # EFF created the HTTPS Everywhere movement
    # TODO: set up a test server for this.
    expect('www.eff.org').to have_a_valid_cert
  end  

  it 'fails if the server is not serving SSL at all' do
    expect {
      # www.psu.edu only supports HTTP, port 80.
      # TODO: set up a test server for this.
      expect('www.psu.edu').to have_a_valid_cert    
    }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
  end
end


# See https://www.eff.org/https-everywhere
describe 'enforce_https_everywhere' do
  it 'passes when http requests are redirected to valid https urls' do
    expect('eff.org').to enforce_https_everywhere
  end
end
