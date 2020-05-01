require "juniter/test_suite_property"

module Juniter
  class TestSuiteProperties < Array

    class << self
      def from_xml(node)
        new(node.nodes.map { |n| TestSuiteProperty.from_xml(n) })
      end
    end

    def to_xml
      Ox::Element.new(:properties).tap do |properties|
        each do |property|
          properties << property.to_xml
        end
      end
    end

  end
end
