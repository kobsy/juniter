require "juniter/element"
require "juniter/test_result"

module Juniter
  class TestCase < Element
    tag "testcase"

    attribute :name, required: true
    attribute :assertion_count, as: :assertions, map: ->(value) { value.to_i }
    attribute :duration, as: :time, map: ->(value) { value.to_f }
    attribute :class_name, as: :classname
    attribute :status

    child :skip_result, as: :skipped, map: ->(node) { TestResult.from_xml(node) }
    child :error_result, as: :error, array: true, map: ->(node) { TestResult.from_xml(node) }
    child :fail_result, as: :failure, array: true, map: ->(node) { TestResult.from_xml(node) }

    child :stdout, as: :"system-out", array: true
    child :stderr, as: :"system-err", array: true

    def all_results
      [ skip_result, *error_result, *fail_result ].compact
    end

    # Convenience method. Assumes that all results are of
    # the same type, which should mean that querying if the
    # "result" is pass/fail/skip/error should work without issue.
    def result
      all_results.none? ? TestResult.new(:pass) : all_results.first
    end

  end
end
