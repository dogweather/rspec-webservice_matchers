# frozen_string_literal: true
require 'web_test/be_up'

RSpec.describe WebTest::BeUp do
  it { is_expected.not_to be_nil }
end
