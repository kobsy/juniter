require "ox"
require "juniter/test_suites"

module Juniter
  class File

    class << self
      def read(io)
        parse io.read
      end

      def from_file(filename)
        ::File.open(filename, "r") do |f|
          read f
        end
      end

      def parse(xml_string)
        new(Ox.parse(xml_string))
      end
    end

    attr_reader :test_suites, :parsed_xml

    def initialize(xml)
      @parsed_xml = xml
      root = xml.respond_to?(:root) ? xml.root : xml
      raise ArgumentError, "Invalid JUnit file. Expected <testsuites> or <testsuite> as the root node but got <#{root.value}>" unless %w{testsuites testsuite}.include?(root.value)
      @test_suites = TestSuites.from_xml(root) if root.value == "testsuites"
      @test_suites ||= TestSuites.new.tap do |test_suites|
        test_suites.test_suites = [ TestSuite.from_xml(root) ]
      end
    end

    def to_xml
      Ox.dump(test_suites.to_xml)
    end

  end
end
