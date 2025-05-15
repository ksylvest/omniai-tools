# frozen_string_literal: true

require "watir"

module OmniAI
  module Tools
    module Browser
      # @example
      #   class SeleniumTool < BaseTool
      #     # ...
      #   end
      class BaseTool < OmniAI::Tool
        # @param logger [IO] An optional logger for debugging executed commands.
        # @param browser [Watir::Browser]
        def initialize(browser:, logger: Logger.new(IO::NULL))
          super()
          @logger = logger
          @browser = browser
        end
      end
    end
  end
end
