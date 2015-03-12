require 'rspec/webservice_matchers/util'

module RSpec
  module WebserviceMatchers
    # Is https is correctly implemented?
    RSpec::Matchers.define :have_a_valid_cert do
      error_message = nil

      match do |domain_name_or_url|
        begin
          Util.try_ssl_connection(domain_name_or_url)
        rescue Exception => e
          error_message = e.message
          false
        end
      end

      failure_message do
        error_message
      end
    end
  end
end
