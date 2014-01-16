require 'rspec/webservice_matchers'

describe 'redirect_permanently_to' do
  it 'passes when receiving a 301 to the given URL' do
    # TODO: Set up a server for this. (Or a mock?)
    expect('http://weblaws.org').to redirect_permanently_to('http://www.weblaws.org/')
  end
end

# See https://www.eff.org/https-everywhere
describe 'enforce_https_everywhere' do
  it 'passes when http requests are redirected to https urls' do
    expect('eff.org').to enforce_https_everywhere
  end
end