require 'cgi'
require 'json'
require 'rspec/webservice_matchers/util'

module RSpec
  module WebserviceMatchers
    module BeFast
      def self.parse(json:)
        response = JSON.parse(json)
        {
          score: response['ruleGroups']['SPEED']['score']
        }
      end

      def self.page_speed_score(url:)
        url_param = CGI.escape(Util.make_url(url))
        key       = ENV['WEBSERVICE_MATCHER_INSIGHTS_KEY']
        endpoint  = 'https://www.googleapis.com/pagespeedonline/v2/runPagespeed'
        api_url = "#{endpoint}?url=#{url_param}&screenshot=false&key=#{key}"
        BeFast.parse(json: Excon.get(api_url).body)[:score]
      end

      RSpec::Matchers.define :be_fast do
        score = nil

        match do |url|
          score = BeFast.page_speed_score(url: url)
          score >= 90
        end

        failure_message do
          "PageSpeed score is #{score}. Score must be 90 or greater."
        end
      end
    end
  end
end
