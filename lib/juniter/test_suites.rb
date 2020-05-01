require "juniter/element"
require "juniter/test_suite"

module Juniter
  class TestSuites < Element
    tag "testsuites"

    attribute :name
    attribute :duration, as: :time, map: ->(value) { value.to_f }
    attribute :test_count, as: :tests, map: ->(value) { value.to_i }
    attribute :failure_count, as: :failures, map: ->(value) { value.to_i }
    attribute :disabled_count, as: :disabled, map: ->(value) { value.to_i }
    attribute :error_count, as: :errors, map: ->(value) { value.to_i }

    child :test_suites, as: :testsuite, array: true, map: ->(node) { TestSuite.from_xml(node) }

  end
end
