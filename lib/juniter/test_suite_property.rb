require "juniter/element"

module Juniter
  class TestSuiteProperty < Element
    tag "property"

    attribute :name
    attribute :value

  end
end
