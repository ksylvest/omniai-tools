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

          @driver.element_click(selector:)
        end
      end
    end
  end
end
