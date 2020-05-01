require "juniter/element"

module Juniter
  class TestResult < Element
    VALID_STATUSES = %i{ pass fail error skip }.freeze

    attribute :type
    attribute :message
    text_child :description

    class << self
      def from_xml(node)
        status = ELEMENT_TO_STATUS_MAP.fetch(node.value, node.value)
        new(status).tap do |element|
          element.assign_attributes_from_xml(node)
          element.assign_children_from_xml(node.nodes)
        end
      end
    end

    def initialize(status)
      self.status = status.to_sym
    end

    attr_reader :status

    def status=(value)
      raise ArgumentError, "Unknown status. Must be one of: #{VALID_STATUSES.join(", ")}" unless VALID_STATUSES.include?(value)
      @status = value
    end

    def to_xml
      return nil if pass?
      super
    end

    def tag
      ELEMENT_TO_STATUS_MAP.invert.fetch(status, status.to_s)
    end

    VALID_STATUSES.each do |status|
      define_method(:"#{status}?") { self.public_send(:status) == :"#{status}" }
    end

    ELEMENT_TO_STATUS_MAP = {
      "skipped" => :skip,
      "failure" => :fail
    }.freeze

  end
end
