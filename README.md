# RSpec::WebserviceMatchers

[![Gem Version](https://badge.fury.io/rb/rspec-webservice_matchers.png)](http://badge.fury.io/rb/rspec-webservice_matchers) [![Build Status](https://travis-ci.org/dogweather/rspec-webservice_matchers.png?branch=master)](https://travis-ci.org/dogweather/rspec-webservice_matchers)

This [gem](https://rubygems.org/gems/rspec-webservice_matchers) enables you to black-box test a web app's server configuration. For example, whether its SSL certificate is correctly configured and not expired. It's a tool for doing **Test Driven Devops**. (I just made that up.) See [my blog post](http://robb.weblaws.org/2014/01/16/new-open-source-library-for-test-driven-devops/) for more about my motivations for making this.

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

                               | Notes
-------------------------------|------------------------------------------------
**be_status**                  |  
**be_up**                      | Follows redirects if necessary and checks for 200
**have_a_valid_cert**          | 
**enforce_https_everywhere**   | See the [EFF project](https://www.eff.org/https-everywhere)
**redirect_permanently_to**    | Checks for 301
**redirect_temporarily_to**    | Checks for 302 or 307


Example
-------

Here's an example which uses them all:

```Ruby
require 'rspec/webservice_matchers'

describe 'My app' do 
  context 'www.myapp.com' do
    it { should be_up }
    it { should have_a_valid_cert }
  end

  it 'serves the "about" page without redirecting' do
    expect('http://www.myapp.com/about').to be_status 200
  end

  it 'only serves via www' do
    expect('http://myapp.com').to redirect_permanently_to 'http://www.myapp.com/'
  end

  it 'forces visitors to use https' do
    expect('myapp.com').to enforce_https_everywhere
  end
end
```

Related Projects
----------------
* [serverspec](http://serverspec.org)
* [HTTP Assertions](https://github.com/dogweather/HTTP-Assertions)


