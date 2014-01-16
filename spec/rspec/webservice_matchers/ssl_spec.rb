require 'rspec/webservice_matchers'

describe 'have_a_valid_cert matcher' do

  it 'passes when SSL is properly configured' do
    # EFF created the HTTPS Everywhere movement
    # TODO: set up test servers for this.
    expect('www.eff.org').to have_a_valid_cert
  end  

  it 'fails if the server is not serving SSL at all' do
    expect {
      # www.psu.edu only supports HTTP, port 80.
      # TODO: set up test servers for this.
      expect('www.psu.edu').to have_a_valid_cert    
    }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
  end

end