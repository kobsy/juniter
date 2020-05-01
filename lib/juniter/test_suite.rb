require "juniter/element"
require "juniter/test_case"
require "juniter/test_suite_properties"

module Juniter
  class TestSuite < Element
    tag "testsuite"

    attribute :name, required: true
    attribute :test_count, as: :tests, required: true, map: ->(value) { value.to_i }
    attribute :failure_count, as: :failures, map: ->(value) { value.to_i }
    attribute :error_count, as: :errors, map: ->(value) { value.to_i }
    attribute :disabled_count, as: :disabled, map: ->(value) { value.to_i }
    attribute :skipped_count, as: :skipped, map: ->(value) { value.to_i }
    attribute :duration, as: :time, map: ->(value) { value.to_f }
    attribute :timestamp, map: ->(value) { Time.parse(value) }
    attribute :hostname
    attribute :id
    attribute :package

    child :test_cases, as: :testcase, array: true, map: ->(node) { TestCase.from_xml(node) }
    child :properties, map: ->(node) { TestSuiteProperties.from_xml(node) }
    child :stdout, as: :"system-out"
    child :stderr, as: :"system-err"

  end
end
