# frozen_string_literal: true
require 'rspec/matchers'
require 'web_test/be_up'

# Pass when the response code is 200, following redirects if necessary.
module RSpec
  module WebserviceMatchers
    module BeUp
      RSpec::Matchers.define :be_up do
        status = nil

        match do |url_or_domain_name|
          result = WebTest::BeUp.test(url: url_or_domain_name)
          status = result.status_code
          result.success?
        end

        failure_message do
          "Received status #{status}"
        end
      end
    end
  end
end
