# Rspec::WebserviceMatchers

This gem enables you to black-box test a web app's server configuration. For example, its SSL certificate for correct configuration and expiration. It's a tool for doing Test Driven Devops. (I just made that up.)

Example
-------

```Ruby
require 'spec_helper'

describe 'My app' do
  it 'is configured for ssl' do
    # New-style RSpec syntax
    expect('www.myapp.com').to have_a_valid_cert
    
    # Old-style RSpec syntax
    'www.weblaws.org'.should have_a_valid_cert
  end
end
```
