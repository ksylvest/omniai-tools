# frozen_string_literal: true

module OmniAI
  module Tools
    module Disk
      # @example
      #   class ExampleTool < OmniAI::Tools::Disk::BaseTool
      #     description "..."
      #   end
      class BaseTool < OmniAI::Tool
        # @param driver [OmniAI::BaseDriver] A driver for interacting with the disk.
        # @param logger [IO] An optional logger for debugging executed commands.
        def initialize(driver:, logger: Logger.new(IO::NULL))
          super()
          @driver = driver
          @logger = logger
        end
      end
    end
  end
end
