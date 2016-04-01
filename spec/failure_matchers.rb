module RSpec
  # Matchers to help test RSpec matchers
  module Matchers
    def fail
      raise_error(RSpec::Expectations::ExpectationNotMetError)
    end

    def fail_with(message)
      raise_error(RSpec::Expectations::ExpectationNotMetError, message)
    end

    def fail_matching(regex)
      raise_error(RSpec::Expectations::ExpectationNotMetError, regex)
    end
  end
end
