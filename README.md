# RSpec::WebserviceMatchers

This gem enables you to black-box test a web app's server configuration. For example, whether its SSL certificate is correctly configured and not expired. It's a tool for doing **Test Driven Devops**. (I just made that up.)

Installation
------------
```Shell
$ gem install rspec-webservice_matchers
```


Example
-------

Currently, two matchers are implemented, `have_a_valid_cert` and `redirect_permanently_to`:

```Ruby
require 'rspec/webservice_matchers'

describe 'My app' do
  it 'is configured for ssl' do
    expect('www.myapp.com').to have_a_valid_cert
  end

  it 'redirects to www' do
    expect('http://myapp.com').to redirect_permanently_to 'http://www.myapp.com/'
  end
end
```


TODO 
----
* Matchers for more HTTP result codes. I'm adding these in by refactoring code out of my [oregonlaws.org](http://www.oregonlaws.org/) and [weblaws.org](http://www.weblaws.org/) projects.
* Matchers for JSON schema 

