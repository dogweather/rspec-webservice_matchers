# RSpec::WebserviceMatchers

This [gem](https://rubygems.org/gems/rspec-webservice_matchers) enables you to black-box test a web app's server configuration. For example, whether its SSL certificate is correctly configured and not expired. It's a tool for doing **Test Driven Devops**. (I just made that up.)

This library takes a very minimalist approach: it simply adds new RSpec matchers,
and so you can use your own RSpec writing style; there's no new DSL to learn.

Installation
------------
```Shell
$ gem install rspec-webservice_matchers
```

What You Get
------------
These new RSpec matchers:

Matcher                        | Notes 
---                            | ---
**be_status**                  |  
**have_a_valid_cert**          | Uses lib-curl to test validity
**enforce_https_everywhere**   | See [EFF](https://www.eff.org/https-everywhere)
**redirect_permanently_to**    | Allows 301
**redirect_temporarily_to**    | Allows 302 or 307


Example
-------

```Ruby
require 'rspec/webservice_matchers'

describe 'My app' do 
  context 'www.myapp.com' do
    it { should be_status 200 }
    it { should have_a_valid_cert }
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
* Matchers for more high-level cases
* Matchers for JSON schema 
* More matchers refactored from [weblaws.org](http://www.weblaws.org/) code

Related Projects
----------------
* [serverspec](http://serverspec.org)
* [HTTP Assertions](https://github.com/dogweather/HTTP-Assertions)


