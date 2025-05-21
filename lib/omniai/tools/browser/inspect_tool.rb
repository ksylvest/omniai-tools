# frozen_string_literal: true

require "nokogiri"
require_relative "html_summarizer"
require_relative "element_formatter"

module OmniAI
  module Tools
    module Browser
      # @example
      # browser = Watir::Browser.new(:chrome)
      # tool = OmniAI::Tools::Browser::InspectTool.new(browser:)
      # tool.execute(selector: 'h1')  # Or tool.execute to use default parameters
      class InspectTool < BaseTool
        description "A browser automation tool for viewing the HTML for the browser."

        parameter :selector, :string, description: "CSS selector to target specific elements"
        parameter :text_content, :string, description: "Search for elements containing this text"
        parameter :context_size, :integer, description: "Number of parent elements to include for context"
        parameter :full_html, :boolean, description: "If true, returns full HTML (may be large)"

        def execute(selector: nil, text_content: nil, context_size: 2, full_html: false)
          @logger.info("#{self.class.name}##{__method__}")

          doc = cleaned_document

          return doc.to_html if full_html
          return find_elements_by_text(doc, text_content, context_size, selector) if text_content
          return process_selector_request(doc, selector, context_size) if selector && !selector.empty?

          generate_page_summary(doc)
        end

      private

        def cleaned_document
          html = @browser.html
          clean_document(Nokogiri::HTML(html))
        end

        def generate_page_summary(doc)
          HtmlSummarizer.summarize_interactive_elements(doc)
        end

        def find_elements_by_text(doc, text, context_size, additional_selector = nil)
          elements = get_elements_matching_text(doc, text, additional_selector)

          return "No elements found containing text: #{text}" if elements.empty?

          ElementFormatter.format_matching_elements(elements, text, context_size)
        end

        def get_elements_matching_text(doc, text, additional_selector)
          text_downcase = text.downcase

          elements = find_elements_with_matching_text(doc, text_downcase)
          elements = add_elements_from_matching_labels(doc, text_downcase, elements)

          # Apply additional CSS selector if provided
          if additional_selector && !additional_selector.empty?
            css_matches = doc.css(additional_selector)
            elements = elements.select { |el| css_matches.include?(el) }
          end

          elements.uniq
        end

        def find_elements_with_matching_text(doc, text_downcase)
          # Match text content and various attributes
          xpath_conditions = [
            ci_contains("text()", text_downcase),
            ci_contains("@value", text_downcase),
            ci_contains("@placeholder", text_downcase),
            ci_contains("@type", text_downcase),
          ].join(" or ")

          doc.xpath("//*[#{xpath_conditions}]")
        end

        def add_elements_from_matching_labels(doc, text_downcase, elements)
          # Find matching label elements
          label_condition = ci_contains("text()", text_downcase)
          matching_labels = doc.xpath("//label[#{label_condition}]")

          # Get input elements associated with the matching labels
          matching_labels.each do |label|
            if label["for"]
              associated_input = doc.css("##{label['for']}")
              elements += associated_input if associated_input.any?
            end
          end

          elements
        end

        # Helper for case-insensitive XPath contains expressions
        def ci_contains(attribute, value)
          "contains(translate(#{attribute}, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', " \
            "'abcdefghijklmnopqrstuvwxyz'), '#{value}')"
        end

        def clean_document(doc)
          doc.css("link, style, script").each(&:remove)
          doc
        end

        def process_selector_request(doc, selector, context_size)
          target_elements = doc.css(selector)

          return "No elements found matching selector: #{selector}" if target_elements.empty?

          result = "Found #{target_elements.size} elements matching '#{selector}':\n\n"

          target_elements.each_with_index do |element, index|
            result += "--- Element #{index + 1} ---\n"
            result += ElementFormatter.get_parent_context(element, context_size) if context_size.positive?
            result += "Element: #{element.to_html}\n\n"
          end

          result
        end
      end
    end
  end
end
