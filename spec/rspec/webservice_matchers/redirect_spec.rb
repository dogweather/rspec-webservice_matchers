# frozen_string_literal: true

require 'spec_helper'
require 'rspec/webservice_matchers'

describe 'redirect_permanently_to' do
  it 'passes when receiving a 301 to the given URL' do
    expect('http://perm-redirector.com').to redirect_permanently_to 'http://www.website.com/'
  end

  it 'handles domain names gracefully' do
    expect('perm-redirector.com').to redirect_permanently_to 'www.website.com/'
  end

  it 'handles a missing final slash' do
    expect('perm-redirector.com').to redirect_permanently_to 'www.website.com'
  end

  it 'gives a good error message for the wrong redirect type' do
    expect do
      expect('temp-redirector.org').to redirect_permanently_to 'http://a-page.com/a/page.txt'
    end.to fail_matching(/temporary/i)
  end

  it 'gives a good error message for a redirect to the wrong location' do
    expect do
      expect('perm-redirector.com').to redirect_permanently_to 'http://the-wrong-site.com/'
    end.to fail_matching(/location/i)
  end

  it 'gives a good error message for a non-redirect status' do
    expect do
      expect('notfound.com').to redirect_permanently_to 'http://the-wrong-site.com/'
    end.to fail_matching(/^not a redirect: received status 404$/i)
  end

  it 'gives a good error message when the hostname is bad' do
    expect do
      expect('not-a-domain.com').to redirect_permanently_to 'http://the-wrong-site.com/'
    end.to fail_matching(/not known/i)
  end
end

describe 'redirect_temporarily_to' do
  it 'passes when it gets a 302' do
    expect('http://temp-redirector.org').to redirect_temporarily_to 'http://a-page.com/a/page.txt'
  end

  it 'handles domain names gracefully' do
    expect('temp-redirector.org').to redirect_temporarily_to 'a-page.com/a/page.txt'
  end

  it 'passes when it gets a 307' do
    expect('temp-307-redirector.net').to redirect_temporarily_to 'a-page.com/a/page.txt'
  end

  it 'gives a good error message for the wrong redirect type' do
    expect do
      expect('perm-redirector.com').to redirect_temporarily_to 'www.website.com/'
    end.to fail_matching(/permanent/i)
  end

  it 'gives a good error message for a redirect to the wrong location' do
    expect do
      expect('temp-307-redirector.net').to redirect_temporarily_to 'www.nowhere.com'
    end.to fail_matching(/location/i)
  end

  it 'gives a good error message for a non-redirect status' do
    expect do
      expect('notfound.com').to redirect_temporarily_to 'www.nowhere.com'
    end.to fail_matching(/^not a redirect: received status 404$/i)
  end

  it 'gives a good error message when the hostname is bad' do
    expect do
      expect('not-a-domain.com').to redirect_temporarily_to 'www.nowhere.com'
    end.to fail_matching(/not known/i)
  end
end
