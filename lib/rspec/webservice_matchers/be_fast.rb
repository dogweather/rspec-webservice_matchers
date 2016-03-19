# frozen_string_literal: true
require 'cgi'
require 'json'
require 'rspec/webservice_matchers/util'

module RSpec
  module WebserviceMatchers
    module BeFast
      def self.parse(json:)
        response = JSON.parse(json)
        unless response.key?('ruleGroups')
          raise "Couldn't parse the PageSpeed response: #{response.inspect}"
        end
        score = response.fetch('ruleGroups').fetch('SPEED').fetch('score')
        { score: score }
      end

      def self.page_speed_score(url:)
        url_param = CGI.escape(Util.make_url(url))
        key       = ENV['WEBSERVICE_MATCHER_INSIGHTS_KEY']
        if key.nil?
          raise 'be_fast requires the WEBSERVICE_MATCHER_INSIGHTS_KEY '\
                'environment variable to be set to a Google PageSpeed '\
                'Insights API key.'
        end
        endpoint  = 'https://www.googleapis.com/pagespeedonline/v2/runPagespeed'
        api_url   = "#{endpoint}?url=#{url_param}&screenshot=false&key=#{key}"
        response = Faraday.get(api_url)
        BeFast.parse(json: response.body).fetch(:score)
      end

      RSpec::Matchers.define :be_fast do
        score = nil

        match do |url|
          score = BeFast.page_speed_score(url: url)
          score >= 85
        end

        failure_message do
          "PageSpeed score is #{score}/100."
        end
      end
    end
  end
end
