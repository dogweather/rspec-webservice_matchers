# RSpec::WebserviceMatchers

[![Gem Version](https://badge.fury.io/rb/rspec-webservice_matchers.png)](http://badge.fury.io/rb/rspec-webservice_matchers) [![Build Status](https://travis-ci.org/dogweather/rspec-webservice_matchers.png?branch=master)](https://travis-ci.org/dogweather/rspec-webservice_matchers) [![Code Climate](https://codeclimate.com/github/dogweather/rspec-webservice_matchers.png)](https://codeclimate.com/github/dogweather/rspec-webservice_matchers)


A [gem](https://rubygems.org/gems/rspec-webservice_matchers) to black-box test a web server configuration. For example, whether a site's SSL certificate is correctly configured and not expired. It's a tool for doing **Test Driven Devops** (I just made that up). See [the introductory blog post](http://robb.weblaws.org/2014/01/16/new-open-source-library-for-test-driven-devops/) for more about the motivations for making this.

This library takes a minimalist approach: it simply adds new RSpec matchers. Therefore, you can use your own RSpec writing style; there's no new DSL to learn.


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
**be_status**                  | A low-level matcher to explicitly check for a 200, 503, or any other code
**be_up**                      | Looks for a 200, but will follow up to four redirects
**have_a_valid_cert**          | Will fail if there's no cert, or it's expired or incorrectly configured
**enforce_https_everywhere**   | Passes if the site will _only_ allow SSL connections. See the [EFF project, HTTP Everywhere](https://www.eff.org/https-everywhere)
**redirect_permanently_to**    | Checks for 301 and a correct destination URL
**redirect_temporarily_to**    | Checks for 302 or 307 and a correct destination


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
* [HTTP Assertions](https://github.com/dogweather/HTTP-Assertions): A precusor to this library. Written in the older test case / assert style.


