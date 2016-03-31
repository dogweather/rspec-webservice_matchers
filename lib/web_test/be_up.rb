# frozen_string_literal: true
require 'validated_object'
require 'web_test/util'

module WebTest
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
        r.status_code = WebTest::Util.status(url || domain, follow: true)
        r.success =     (r.status_code == 200)
      end
    end
  end
end
