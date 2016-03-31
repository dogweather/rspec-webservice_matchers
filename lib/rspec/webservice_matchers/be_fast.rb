# frozen_string_literal: true
require 'rspec/matchers'
require 'web_test/be_fast'

module RSpec
  module WebserviceMatchers
    module BeFast
      RSpec::Matchers.define :be_fast do
        score = nil

        match do |url|
          result = WebTest::BeFast.test(url: url)
          score = result.score
          result.success?
        end

        failure_message do
          "PageSpeed score is #{score}/100."
        end
      end
    end
  end
end
