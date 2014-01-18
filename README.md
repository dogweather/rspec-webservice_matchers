# RSpec::WebserviceMatchers

This [gem](https://rubygems.org/gems/rspec-webservice_matchers) enables you to black-box test a web app's server configuration. For example, whether its SSL certificate is correctly configured and not expired. It's a tool for doing **Test Driven Devops**. (I just made that up.)

Installation
------------
```Shell
$ gem install rspec-webservice_matchers
```

What You Get
------------
Three new RSpec matchers:

* `be_status`
* `have_a_valid_cert`
* `enforce_https_everywhere` (See [EFF](https://www.eff.org/https-everywhere))
* `redirect_permanently_to`


Example
-------

```Ruby
require 'rspec/webservice_matchers'

describe 'My app' do 
  it 'has a working home page' do
    expect('www.myapp.com').to be_status 200
  end

  it 'is configured for ssl' do
    expect('www.myapp.com').to have_a_valid_cert
  end

  it 'redirects to www' do
    expect('http://myapp.com').to redirect_permanently_to 'http://www.myapp.com/'
  end

  it 'forces visitors to use https' do
    expect('myapp.com').to enforce_https_everywhere
  end
end
```


TODO 
----
* Matchers for more HTTP result codes. I'm adding these in by refactoring code out of my [oregonlaws.org](http://www.oregonlaws.org/) and [weblaws.org](http://www.weblaws.org/) projects.
* Matchers for JSON schema 

Related Projects
----------------
* [serverspec](http://serverspec.org)
* [HTTP Assertions](https://github.com/dogweather/HTTP-Assertions)
