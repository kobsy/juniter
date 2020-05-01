module Juniter
  module HasAttributes

    class UnsetAttributeError < StandardError; end

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      def attribute(name, as: nil, required: false, validation: nil, map: nil)
        attributes << name
        attribute_aliases[name] = as unless as.nil?
        attribute_processors[name] = map || ->(value) { value }

        define_method :"#{name}" do
          instance_variable_get :"@_#{name}" if instance_variable_defined?(:"@_#{name}")
        end

        define_method :"#{name}=" do |value|
          send validation, value unless validation.nil?
          instance_variable_set :"@_#{name}", value
        end
      end

      def attributes
        @__attributes ||= []
      end

      def attribute_aliases
        @__attribute_aliases ||= {}
      end

      def attribute_processors
        @__attribute_processors ||= {}
      end

      def required_attributes
        @__required_attributes ||= []
      end

    end

    def assign_attributes_from_xml(node)
      attributes = node.attributes
      self.class.attributes.each do |name|
        key = self.class.attribute_aliases.fetch(name, name).to_sym
        mapped = attributes.key?(key) ? self.class.attribute_processors[name].call(node[key]) : nil
        public_send "#{name}=", mapped
      end
    end

    def xml_attributes
      self.class.attributes.each_with_object({}) do |name, hash|
        key = self.class.attribute_aliases.fetch(name, name)
        value = public_send(name)
        raise UnsetAttributeError if self.class.required_attributes.include?(name) && value.nil?
        hash[key] = public_send(name)
      end
    end

  protected

    def valid_number?(value)
      raise ArgumentError, "Must be a number" unless value.is_a?(Numeric)
    end

  end
end
