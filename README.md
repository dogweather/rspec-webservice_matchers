# RSpec::WebserviceMatchers

[![Gem Version](https://badge.fury.io/rb/rspec-webservice_matchers.svg)](https://badge.fury.io/rb/rspec-webservice_matchers)

A [gem](https://rubygems.org/gems/rspec-webservice_matchers) to black-box test a web server configuration. For example, whether a site's SSL certificate is correctly configured and not expired:

```ruby
expect('github.com').to have_a_valid_cert
```

It's a tool for doing **Test Driven Devops** (I just made that up). See [my introductory blog post](https://dogsnog.blog/2014/01/16/new-open-source-library-for-test-driven-devops/) for the backstory.

This library takes a minimalist approach: it simply adds new RSpec matchers. Therefore, you can use your own RSpec writing style; there's no new DSL to learn.



Installation
------------
```Shell
$ gem install rspec-webservice_matchers
```

What You Get
------------
These new RSpec matchers:

|                               | Notes
|-------------------------------|------------------------------------------------
|**be_up**                      | Looks for a 200, but will follow up to four redirects
|**be_fast**                    | Checks for Google [PageSpeed](https://developers.google.com/speed/pagespeed/insights/) score >= 85. Expects the environment variable `WEBSERVICE_MATCHER_INSIGHTS_KEY` to contain a [Google "server" API key](https://developers.google.com/speed/docs/insights/v2/getting-started) with PageSpeed Insights API enabled.
|**enforce_https_everywhere**   | Passes if the site will _only_ allow SSL connections. See the [EFF project, HTTPS Everywhere](https://www.eff.org/https-everywhere)
|**have_a_valid_cert**          | Will fail if there's no cert, or it's expired or incorrectly configured
|**be_status**                  | A low-level matcher to explicitly check for a 200, 503, or any other code
|**redirect_permanently_to**    | Checks for 301 and a correct destination URL
|**redirect_temporarily_to**    | Checks for 302 or 307 and a correct destination


Example
-------

Here's an example which uses them all:

```Ruby
require 'rspec/webservice_matchers'

describe 'My app' do
  context 'www.myapp.com' do
    it { should be_up }
    it { should be_fast }
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
* [json-schema-rspec](https://github.com/sharethrough/json-schema-rspec)
* [serverspec](http://serverspec.org)
* [HTTP Assertions](https://github.com/dogweather/HTTP-Assertions): A precusor to this library. Written in the older test case / assert style.
