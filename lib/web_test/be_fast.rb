# frozen_string_literal: true
require 'cgi'
require 'json'
require 'validated_object'
require 'web_test/util'

module WebTest
  module BeFast
    class TestResult < ValidatedObject::Base
      attr_accessor :success, :score
      alias success? success

      validates :success, inclusion: [true, false]
      validates :score,   inclusion: 0..100
    end


    def self.test(url:)
      response = page_speed_response(url: url)

      TestResult.new do |r|
        r.score   = score(response: response)
        r.success = r.score >= 85
      end
    end

    def self.page_speed_response(url:)
      url_param = CGI.escape(WebTest::Util.make_url(url))
      key       = ENV['WEBSERVICE_MATCHER_INSIGHTS_KEY']
      if key.nil?
        raise 'be_fast requires the WEBSERVICE_MATCHER_INSIGHTS_KEY '\
              'environment variable to be set to a Google PageSpeed '\
              'Insights API key.'
      end
      endpoint  = 'https://www.googleapis.com/pagespeedonline/v2/runPagespeed'
      api_url   = "#{endpoint}?url=#{url_param}&screenshot=false&key=#{key}"
      Faraday.get(api_url)
    end

    def self.score(response:)
      parse(json: response.body).fetch(:score)
    end

    def self.parse(json:)
      response = JSON.parse(json)
      # require('pry'); binding.pry
      unless response.key?('ruleGroups')
        raise "Couldn't parse the PageSpeed response: #{response.inspect}"
      end
      score = response.fetch('ruleGroups').fetch('SPEED').fetch('score')
      {
        score: score,
        raw_response: response
      }
    end
  end
end
