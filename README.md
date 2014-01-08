# Rspec::WebserviceMatchers

I'm currently factoring out my code into this new repo. Check back around January 9.

Here's the idea. This gem enables you to check a web app's HTTP configuration. For example, it's SSL certificate for correct configuration and expiration.

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
