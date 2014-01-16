# Rspec::WebserviceMatchers

This gem enables you to black-box test a web app's server configuration. For example, whether its SSL certificate is correctly configured and not expired. It's a tool for doing **Test Driven Devops**. (I just made that up.)

TODO: Finish the Gem set up and register as a Gem.


Example
-------

```Ruby
require 'rspec/webservice_matchers'

describe 'My app' do
  it 'is configured for ssl' do
    # New-style RSpec syntax
    expect('www.myapp.com').to have_a_valid_cert
    
    # Old-style RSpec syntax
    'www.weblaws.org'.should have_a_valid_cert
  end
end
```
