require 'rspec/webservice_matchers/util'

module RSpec
  module WebserviceMatchers
    module BeStatus
      # Pass when a URL returns the expected status code
      # Codes are defined in http://www.rfc-editor.org/rfc/rfc2616.txt
      RSpec::Matchers.define :be_status do |expected_code|
        actual_code = nil
        
        match do |url_or_domain_name|
          actual_code = Util.status(url_or_domain_name)
          actual_code == expected_code.to_i
        end
        
        failure_message do
          "Received status #{actual_code}"
        end
      end
    end
  end
end
