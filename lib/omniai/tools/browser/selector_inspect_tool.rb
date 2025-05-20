# frozen_string_literal: true

require "nokogiri"

module OmniAI
  module Tools
    module Browser
      # A browser automation tool for inspecting elements using CSS selectors.
      class SelectorInspectTool < BaseTool
        include InspectUtils

        description "A browser automation tool for finding and inspecting elements by CSS selector."

        parameter :selector, :string, description: "CSS selector to target specific elements"
        parameter :context_size, :integer, description: "Number of parent elements to include for context"

        def execute(selector:, context_size: 2)
          @logger.info("#{self.class.name}##{__method__}")

          doc = cleaned_document(html: @driver.html)
          target_elements = doc.css(selector)

          return "No elements found matching selector: #{selector}" if target_elements.empty?

          format_elements(target_elements, selector, context_size)
        end

      private

        def format_elements(elements, selector, context_size)
          result = "Found #{elements.size} elements matching '#{selector}':\n\n"

          elements.each_with_index do |element, index|
            result += "--- Element #{index + 1} ---\n"
            result += Formatters::ElementFormatter.get_parent_context(element, context_size) if context_size.positive?
            result += "Element: #{element.to_html}\n\n"
          end

          result
        end
      end
    end
  end
end
