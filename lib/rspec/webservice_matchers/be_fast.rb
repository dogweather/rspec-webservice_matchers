require 'rspec/webservice_matchers/util'

module RSpec
  module WebserviceMatchers
    module BeFast
      RSpec::Matchers.define :be_score do
        score = nil

        match do |url_or_domain_name|
          score = Util.page_speed_score(url_or_domain_name)
          score >= 90
        end

        failure_message do
          "Received score #{score}"
        end
      end
    end
  end
end
