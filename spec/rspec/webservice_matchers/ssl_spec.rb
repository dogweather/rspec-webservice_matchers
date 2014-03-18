require 'spec_helper'
require 'rspec/webservice_matchers'

# VCR may be the tool to use for this. Can it handle https? Would that work?


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
    pending 'Not sure what the message can look like'
    expect {
      expect('www.psu.edu').to have_a_valid_cert    
    }.to fail_matching(/SSL/)
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
end
