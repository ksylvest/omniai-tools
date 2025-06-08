# frozen_string_literal: true

module OmniAI
  module Tools
    module Browser
      # @example
      #   browser = Watir::Browser.new(:chrome)
      #   tool = OmniAI::Tools::Browser::ClickTool.new(browser:)
      #   tool.execute(selector: "#some-id")
      #   tool.execute(selector: ".some-class")
      #   tool.execute(selector: "some text")
      #   tool.execute(selector: "//div[@role='button']")
      class ClickTool < BaseTool
        description "A browser automation tool for clicking any clickable element."

        parameter :selector, :string, description: <<~TEXT
          A CSS selector to locate or interact with an element on the page:

           * 'form button[type="submit"]': selects a button with type submit
           * '.example': selects elements with the foo and bar classes
           * '#example': selects an element by ID
           * 'div#parent > span.child': selects span elements that are direct children of div elements
           * 'a[href="/login"]': selects an anchor tag with a specific href attribute
        TEXT

        required %i[selector]

        # @param selector [String] CSS selector, ID, text content, or other identifier for the element to click.
        def execute(selector:)
          @logger.info("#{self.class.name}##{__method__} selector=#{selector.inspect}")

          @driver.click(selector:)
        end
      end
    end
  end
end
