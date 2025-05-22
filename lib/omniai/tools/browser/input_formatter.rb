# frozen_string_literal: true

module OmniAI
  module Tools
    module Browser
      # Handles formatting of input elements
      module InputFormatter
      module_function

        def format_input_field(input, indent = "")
          result = "#{indent}• #{input_type_display(input)}"
          result += input_id_display(input)
          result += input_value_display(input)
          result += input_placeholder_display(input)
          "#{result}\n"
        end

        def input_type_display(input)
          (input["type"] || input.name).capitalize
        end

        def input_id_display(input)
          input["id"] ? " (#{input['id']})" : ""
        end

        def input_value_display(input)
          input["value"] && !input["value"].empty? ? " = '#{input['value']}'" : ""
        end

        def input_placeholder_display(input)
          input["placeholder"] && !input["placeholder"].empty? ? " [#{input['placeholder']}]" : ""
        end
      end
    end
  end
end
