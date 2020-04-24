require "juniter/has_attributes"
require "juniter/has_children"

module Juniter
  class Element
    include HasAttributes
    include HasChildren

    class << self
      def tag(*args)
        @__tag = args.first.to_s unless args.none?
        @__tag
      end

      def from_xml(node)
        new.tap do |element|
          element.assign_attributes_from_xml(node)
          element.assign_children_from_xml(node.nodes)
        end
      end
    end

    def to_xml
      Ox::Element.new(tag).tap do |element|
        xml_attributes.each do |key, value|
          element[key.to_s] = value unless value.nil?
        end
        children_xml.each do |child|
          element << child
        end
      end
    end

  protected

    def tag
      self.class.tag
    end

  end
end
