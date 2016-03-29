# frozen_string_literal: true
require 'rspec/webservice_matchers/util'
require 'validated_object'

# Pass when the response code is 200, following redirects if necessary.
module RSpec
  module WebserviceMatchers
    module BeUp

      class TestResult < ValidatedObject::Base
        attr_accessor :success, :status_code
        alias success? success

        validates :success,     inclusion: [true, false]
        validates :status_code, inclusion: 100..510
      end


      def self.test(url:nil, domain:nil)
        raise 'Must specify a url or domain' if url.nil? && domain.nil?
        
        TestResult.new do |r|
          r.status_code = Util.status(url || domain, follow: true)
          r.success =     (r.status_code == 200)
        end
      end


      RSpec::Matchers.define :be_up do
        status = nil

        match do |url_or_domain_name|
          result = BeUp.test(url: url_or_domain_name)
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
