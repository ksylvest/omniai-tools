# frozen_string_literal: true

module OmniAI
  module Tools
    module Browser
      # Module to handle HTML formatting and summary generation
      module HtmlSummarizer
      module_function

        def summarize_interactive_elements(doc)
          summary = "Page Structure Summary:\n\n"
          title = doc.at_css("title")&.text || "No title"
          summary += "Title: #{title}\n\n"

          summary += summarize_form_fields(doc)
          summary += summarize_buttons(doc)
          summary += summarize_links(doc)
          summary += summarize_forms(doc)

          summary
        end

        def summarize_form_fields(doc)
          fields = doc.css("input, textarea, select")
          return "Form Fields:\n- No form fields found\n\n" if fields.empty?

          result = "Form Fields:\n"
          fields.each_with_index do |field, index|
            result += format_field(field, index)
          end

          result += "\n"
          result
        end

        def format_field(field, index)
          field_type = get_field_type(field)
          field_id = field["id"] || "(no id)"
          field_name = field["name"] || "(no name)"

          result = "- Field #{index + 1}: #{field_type} - id=\"#{field_id}\" name=\"#{field_name}\""
          result += " placeholder=\"#{field['placeholder']}\"" if field["placeholder"]
          result += "\n"

          result
        end

        def get_field_type(field)
          field.name == "input" ? field["type"] || "text" : field.name
        end

        def summarize_buttons(doc)
          buttons = doc.css('button, input[type="button"], input[type="submit"], [role="button"]')
          return "Buttons:\n- No buttons found\n\n" if buttons.empty?

          result = "Buttons:\n"
          buttons.each_with_index do |button, index|
            result += format_button(button, index)
          end

          result += "\n"
          result
        end

        def format_button(button, index)
          button_text = get_button_text(button)
          button_id = button["id"] || "(no id)"
          button_type = button.name == "input" ? button["type"] : "button"

          "- Button #{index + 1}: \"#{button_text}\" - type=\"#{button_type}\" id=\"#{button_id}\"\n"
        end

        def get_button_text(button)
          text = button.text.strip
          text = button["value"] if text.empty? && button["value"]
          text.empty? ? "(no text)" : text
        end

        def summarize_links(doc)
          links = doc.css("a")
          return "Links:\n- No links found\n\n" if links.empty?

          result = "Links:\n"
          display_links = links.first(10)

          display_links.each_with_index do |link, index|
            result += format_link(link, index)
          end

          result += "- ... and #{links.size - 10} more links\n" if links.size > 10

          result += "\n"
          result
        end

        def format_link(link, index)
          link_text = link.text.strip.empty? ? "(no text)" : link.text.strip
          link_href = link["href"] || "#"
          link_id = link["id"] || "(no id)"

          "- Link #{index + 1}: \"#{link_text}\" - href=\"#{link_href}\" id=\"#{link_id}\"\n"
        end

        def summarize_forms(doc)
          forms = doc.css("form")
          return "" if forms.empty?

          result = "Forms:\n"
          forms.each_with_index do |form, index|
            result += format_form(form, index)
          end

          result
        end

        def format_form(form, index)
          form_id = form["id"] || "(no id)"
          form_action = form["action"] || "(no action)"
          form_method = form["method"] || "get"

          "- Form #{index + 1}: id=\"#{form_id}\" action=\"#{form_action}\" method=\"#{form_method}\"\n"
        end
      end
    end
  end
end
