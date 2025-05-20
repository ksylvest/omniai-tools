# frozen_string_literal: true

require "base64"

module OmniAI
  module Tools
    module Browser
      # A browser automation tool for taking screenshots of the current page.
      class PageScreenshotTool < BaseTool
        description "A browser automation tool for taking screenshots of the current page."

        def execute
          @logger.info("#{self.class.name}##{__method__}")

          @driver.screenshot do |file|
            "data:image/png;base64,#{Base64.strict_encode64(file.read)}"
          end
        end
      end
    end
  end
end
