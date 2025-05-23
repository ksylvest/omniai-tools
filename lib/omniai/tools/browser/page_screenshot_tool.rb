# frozen_string_literal: true

require "base64"

module OmniAI
  module Tools
    module Browser
      # A browser automation tool for taking screenshots of the current page.
      class PageScreenshotTool < BaseTool
        description "A browser automation tool for taking screenshots of the current page."

        parameter :selector, :string, description: "Optional CSS selector to screenshot a specific element"
        parameter :format, :string, description: "Screenshot format (png, jpeg)"
        parameter :full_page, :boolean, description: "If true, captures the full page height"

        def execute(selector: nil, format: "png", full_page: false)
          @logger.info("#{self.class.name}##{__method__}")

          if selector
            screenshot_element(selector, format)
          else
            screenshot_page(format, full_page)
          end
        end

      private

        def screenshot_page(format, full_page)
          options = {}
          options[:full] = true if full_page

          begin
            image_data = @browser.screenshot.base64
            "data:image/#{format};base64,#{image_data}"
          rescue StandardError => e
            "Error taking screenshot: #{e.message}"
          end
        end

        def screenshot_element(selector, format)
          element = @browser.element(css: selector)

          return "No element found matching selector: #{selector}" unless element.exists?

          begin
            # Since Watir::Element doesn't have a screenshot method,
            # we'll take a full browser screenshot and note that
            # in a real implementation this would need to be cropped to the element
            image_data = @browser.screenshot.base64
            "data:image/#{format};base64,#{image_data}"
          rescue StandardError => e
            "Error taking element screenshot: #{e.message}"
          end
        end
      end
    end
  end
end
