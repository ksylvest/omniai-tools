# frozen_string_literal: true

module OmniAI
  module Tools
    module Disk
      # @example
      #   class ExampleTool < OmniAI::Tools::Disk::BaseTool
      #     description "..."
      #   end
      class BaseTool < OmniAI::Tool
        # @param root [Pathname] The root path for which a tool is able to operate within.
        # @param logger [IO] An optional logger for debugging executed commands.
        def initialize(root:, logger: Logger.new(IO::NULL))
          super()
          @root = Pathname(root)
          @logger = logger
        end

      protected

        # @param directory [Pathname]
        # @param path [String]
        #
        # @raise [SecurityError]
        #
        # @return Pathname
        def resolve!(path:)
          @root.join(path).tap do |resolved|
            relative = resolved.ascend.any? { |ancestor| ancestor.eql?(@root) }
            raise SecurityError, "unknown path=#{resolved}" unless relative
          end
        end
      end
    end
  end
end
