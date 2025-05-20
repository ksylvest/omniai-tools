# frozen_string_literal: true

require "nokogiri"

module OmniAI
  module Tools
    module Browser
      # A browser automation tool for finding UI elements by their text content.
      class InspectTool < BaseTool
        include InspectUtils

        description "A browser automation tool for finding UI elements by their text content."

        parameter :text_content, :string, description: "Search for elements containing this text"
        parameter :selector, :string, description: "Optional CSS selector to further filter results"
        parameter :context_size, :integer, description: "Number of parent elements to include for context"

        def execute(text_content:, selector: nil, context_size: 2)
          @logger.info("#{self.class.name}##{__method__}")

          html = @driver.html

          @logger.info("#{self.class.name}##{__method__} html=#{html}")

          doc = cleaned_document(html: @driver.html)
          find_elements_by_text(doc, text_content, context_size, selector)
        end

      private

        def find_elements_by_text(doc, text, context_size, additional_selector = nil)
          elements = get_elements_matching_text(doc, text, additional_selector)

          return "No elements found containing text: #{text}" if elements.empty?

          adjusted_context_size = additional_selector ? 0 : context_size

          Formatters::ElementFormatter.format_matching_elements(elements, text, adjusted_context_size)
        end

        def get_elements_matching_text(doc, text, additional_selector)
          text_downcase = text.downcase

          elements = find_elements_with_matching_text(doc, text_downcase)

          elements = add_elements_from_matching_labels(doc, text_downcase, elements)

          unless additional_selector && !additional_selector.empty?
            elements = Elements::NearbyElementDetector.add_nearby_interactive_elements(elements)
          end

          apply_additional_selector(doc, elements, additional_selector)
        end

        def apply_additional_selector(doc, elements, additional_selector)
          return elements.uniq unless additional_selector && !additional_selector.empty?

          css_matches = doc.css(additional_selector)
          elements.select { |el| css_matches.include?(el) }.uniq
        end
      end
    end
  end
end
