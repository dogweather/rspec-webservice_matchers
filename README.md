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

* `have_a_valid_cert`
* `redirect_permanently_to`
* `enforce_https_everywhere` (See the [EFF site](https://www.eff.org/https-everywhere) for more info)


Example
-------

```Ruby
require 'rspec/webservice_matchers'

describe 'My app' do
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

