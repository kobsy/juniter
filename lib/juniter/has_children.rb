module Juniter
  module HasChildren

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def child(name, as: nil, array: false, map: nil)
        child_types << name
        child_aliases[name] = as unless as.nil?
        child_processors[name] = map || ->(node) { node.text }
        array_children << name if array

        define_method :"#{name}" do
          instance_variable_set(:"@_#{name}", array ? [] : nil ) unless instance_variable_defined?(:"@_#{name}")
          instance_variable_get(:"@_#{name}")
        end

        define_method :"#{name}=" do |value|
          instance_variable_set :"@_#{name}", value
        end
      end

      def text_child(*args)
        if args.any?
          @__text_child = args.first
          child(args.first)
        end
        @__text_child
      end

      def child_types
        @__child_types ||= []
      end

      def child_processors
        @__child_processors ||= {}
      end

      def child_aliases
        @__child_aliases ||= {}
      end

      def array_children
        @__array_children ||= []
      end
    end

    def assign_children_from_xml(nodes)
      child_map = self.class.child_types.each_with_object({}) do |name, hash|
        hash[self.class.child_aliases.fetch(name, name).to_s] = name
      end

      nodes.each do |node|
        next if node.is_a?(Ox::Comment)

        if node.is_a?(String) || node.is_a?(Ox::CData)
          value = node.is_a?(String) ? node : node.value
          text_child = self.class.text_child
          next unless text_child
          public_send :"#{text_child}=", [ public_send(:"#{text_child}"), value ].join
          next
        end

        name = child_map.fetch(node.value)
        mapped = self.class.child_processors[name].call(node)
        if self.class.array_children.include?(name)
          public_send("#{name}") << mapped
        else
          public_send "#{name}=", mapped
        end
      end
    end

    def children_xml
      self.class.child_types.each_with_object([]) do |name, children|
        value = public_send(name)
        next if value.nil?

        element = self.class.child_aliases.fetch(name, name)
        if self.class.array_children.include?(name)
          children.concat value.map { |child|
            child.respond_to?(:to_xml) ? child.to_xml : Ox::Element.new(element).tap { |el| el << child }
          }
        elsif self.class.text_child == name
          children << value
        else
          children << (value.respond_to?(:to_xml) ? value.to_xml : Ox::Element.new(element).tap { |el| el << value })
        end
      end
    end

  end
end
