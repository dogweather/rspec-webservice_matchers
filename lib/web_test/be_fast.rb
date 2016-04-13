# frozen_string_literal: true
require 'cgi'
require 'json'
require 'validated_object'
require 'web_test/util'

#
# Runs PageSpeed on a URL.
# See https://developers.google.com/speed/docs/insights/v2/reference/pagespeedapi/runpagespeed#response
#
module WebTest
  module BeFast

    class TestResult < ValidatedObject::Base
      attr_accessor :success, :score, :response
      alias success? success

      validates :success,  type: Boolean
      validates :score,    inclusion: 0..100
      validates :response, type: Hash
    end


    def self.test(url:)
      response = page_speed(url: url)

      TestResult.new do |r|
        r.score    = response.fetch(:score)
        r.success  = r.score >= 85
        r.response = response
      end
    end

    def self.page_speed(url:)
      url_param = CGI.escape(WebTest::Util.make_url(url))
      key       = ENV['WEBSERVICE_MATCHER_INSIGHTS_KEY']
      if key.nil?
        raise 'be_fast requires the WEBSERVICE_MATCHER_INSIGHTS_KEY '\
              'environment variable to be set to a Google PageSpeed '\
              'Insights API key.'
      end
      endpoint  = 'https://www.googleapis.com/pagespeedonline/v2/runPagespeed'
      api_url   = "#{endpoint}?url=#{url_param}&screenshot=false&key=#{key}"
      parse json: Faraday.get(api_url).body
    end

    def self.parse(json:)
      raw_response = JSON.parse(json)
      unless raw_response.key?('ruleGroups')
        raise "Couldn't parse the PageSpeed raw_response: #{raw_response.inspect}"
      end
      score = raw_response.fetch('ruleGroups').fetch('SPEED').fetch('score')
      {
        score: score,
        raw_response: raw_response
      }
    end
  end
end
