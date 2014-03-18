require 'webmock/rspec'
require 'rspec/webservice_matchers'

#
# TODO: set up mocks or VCR for the rest of these.
# SEE:  http://www.slideshare.net/kjbuckley/testing-http-calls-with-webmock-and-vcr
#

WebMock.stub_request :any, 'http://www.website.com/a/page.txt'
WebMock.stub_request :any, 'http://www.website.com/'

WebMock.allow_net_connect!


describe 'status_code' do
  it 'can check 200 for successful resource requests' do
    'http://www.website.com/a/page.txt'.should be_status 200
  end

  it 'handles domain names as well as URLs' do
    'www.website.com'.should be_status 200
  end

  it 'accepts status code in text form too' do
    'www.website.com'.should be_status '200'
  end

  it 'can check 503 for the Service Unavailable status' do
    'http://www.weblaws.org/texas/laws/tex._spec._dist._local_laws_code_section_1011.202_tax_to_pay_general_obligation_bonds'.should be_status 503
  end
end


describe 'be_up' do
  let(:rfc_url) {'http://www.rfc-editor.org/rfc/rfc2616.txt'}

  it 'follows redirects when necessary' do
    'weblaws.org'.should be_up
  end

  it 'can also handle a simple 200' do
    rfc_url.should be_up
  end

  it 'is available via a public API' do
    RSpec::WebserviceMatchers.up?(rfc_url).should be true
  end
end
