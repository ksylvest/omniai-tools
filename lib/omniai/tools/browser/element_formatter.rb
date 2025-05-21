# frozen_string_literal: true

module OmniAI
  module Tools
    module Browser
      # Handles formatting of HTML elements for display
      module ElementFormatter
      module_function

        def format_matching_elements(elements, text, context_size)
          result = "Found #{elements.size} elements containing '#{text}':\n\n"

          elements.each_with_index do |element, index|
            result += format_single_element(element, index, context_size)
          end

          result
        end

        def format_single_element(element, index, context_size)
          result = "--- Element #{index + 1} ---\n"
          result += "Tag: #{element.name}\n"

          result += format_element_attributes(element)
          result += get_parent_context(element, context_size) if context_size.positive?

          result += "HTML: #{element.to_html}\n\n"

          result
        end

        def format_element_attributes(element)
          result = ""

          result += "ID: #{element['id']}\n" if element["id"]
          result += "Classes: #{element['class']}\n" if element["class"]

          %w[href src alt type value placeholder].each do |attr|
            result += "#{attr}: #{element[attr]}\n" if element[attr] && !element[attr].empty?
          end

          result
        end

        def get_parent_context(element, context_size)
          result = ""
          parent = element.parent
          context_count = 0

          while parent && context_count < context_size
            attrs = parent.attributes.map { |name, attr| " #{name}=\"#{attr.value}\"" }.join
            result += "Parent #{context_count + 1}: <#{parent.name}#{attrs}>\n"
            parent = parent.parent
            context_count += 1
          end

          result
        end
      end
    end
  end
end
