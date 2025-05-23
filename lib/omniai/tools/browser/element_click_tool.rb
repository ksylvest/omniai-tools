# frozen_string_literal: true

module OmniAI
  module Tools
    module Browser
      # @example
      #   browser = Watir::Browser.new(:chrome)
      #   tool = OmniAI::Tools::Browser::ElementClickTool.new(browser:)
      #   tool.execute(selector: "#some-id")
      #   tool.execute(selector: ".some-class")
      #   tool.execute(selector: "some text")
      #   tool.execute(selector: "//div[@role='button']")
      class ElementClickTool < BaseTool
        description "A browser automation tool for clicking any clickable element."

        parameter :selector, :string,
          description: "CSS selector, ID, text content, or other identifier for the element to click."

        required %i[selector]

        # @param selector [String] CSS selector, ID, text content, or other identifier for the element to click.
        def execute(selector:)
          @logger.info("#{self.class.name}##{__method__} selector=#{selector.inspect}")

          element = find_by_css(selector) ||
            find_by_text(selector) ||
            find_by_id(selector) ||
            find_by_xpath(selector)

          return { error: "unknown selector=#{selector}" } if element.nil?

          element.click

          # Return a meaningful string that includes information about the selector
          "Successfully clicked element with selector: #{selector}"
        end

      protected

        # @param selector [String] CSS selector to find the element
        # @return [Watir::Element, nil]
        def find_by_css(selector)
          element = @browser.element(css: selector)
          return nil unless element.respond_to?(:exists?)

          element if element.exists?
        end

        # @param text [String] The text content of the element to find
        # @return [Watir::Element, nil]
        def find_by_text(text)
          element = @browser.element(text:)
          return nil unless element.respond_to?(:exists?)

          element if element.exists?
        end

        # @param id [String] The ID of the element to find
        # @return [Watir::Element, nil]
        def find_by_id(id)
          element = @browser.element(id:)
          return nil unless element.respond_to?(:exists?)

          element if element.exists?
        end

        # @param xpath [String] XPath expression to find the element
        # @return [Watir::Element, nil]
        def find_by_xpath(xpath)
          element = @browser.element(xpath:)
          return nil unless element.respond_to?(:exists?)

          element if element.exists?
        rescue StandardError => e
          @logger.error("XPath error: #{e.message}")
          nil
        end
      end
    end
  end
end
