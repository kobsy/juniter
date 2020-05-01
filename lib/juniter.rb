require "juniter/version"
require "juniter/file"

# Initial implementation based on the XSD found at
# https://llg.cubic.org/docs/junit/

module Juniter
  class << self
      def read(*args)
        Juniter::File.read(*args)
      end

      def from_file(*args)
        Juniter::File.from_file(*args)
      end

      def parse(*args)
        Juniter::File.parse(*args)
      end
  end
end
