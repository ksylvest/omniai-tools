# frozen_string_literal: true

require "sqlite3"

module OmniAI
  module Tools
    module Browser
      # @example
      #   browser = Watir::Browser.new(:chrome)
      #   tool = OmniAI::Tools::Browser::TextFieldSetTool.new(browser:)
      #   tool.execute(selector: "...", text: "...")
      class TextFieldAreaSetTool < BaseTool
        description "A browser automation tool for clicking a specific link."

        parameter :selector, :string, description: "The ID / name of the text field / area to interact with."
        parameter :text, :string, description: "The text to set."

        required %i[selector]

        # @param selector [String] The ID / name of the text field / text area to interact with.
        # @param text [String] The text to set.
        def execute(selector:, text:)
          @logger.info("#{self.class.name}##{__method__} selector=#{selector.inspect}")

          element = find_by_id(selector) || find_by_name(selector)

          return { error: "unknown selector=#{selector}" } if element.nil?

          element.set(text)

          # Return a meaningful string that includes information about the selector and text
          "Successfully set text for input with selector: #{selector}"
        end

      protected

        # @param id [String] The ID of the element to find
        # @return [Watir::TextArea, Watir::TextField, nil]
        def find_by_id(id)
          find_text_area_by_id(id) || find_text_field_by_id(id)
        end

        # @param name [String] The name of the element to find
        # @return [Watir::TextArea, Watir::TextField, nil]
        def find_by_name(name)
          find_text_area_by_name(name) || find_text_field_by_name(name)
        end

        # @param id [String] The ID of the textarea to find
        # @return [Watir::TextArea, nil]
        def find_text_area_by_id(id)
          element = @browser.textarea(id:)
          return nil unless element.respond_to?(:exists?)

          element if element.exists?
        end

        # @param name [String] The name of the textarea to find
        # @return [Watir::TextArea, nil]
        def find_text_area_by_name(name)
          element = @browser.textarea(name:)
          return nil unless element.respond_to?(:exists?)

          element if element.exists?
        end

        # @param id [String] The ID of the text field to find
        # @return [Watir::TextField, nil]
        def find_text_field_by_id(id)
          element = @browser.text_field(id:)
          return nil unless element.respond_to?(:exists?)

          element if element.exists?
        end

        # @param name [String] The name of the text field to find
        # @return [Watir::TextField, nil]
        def find_text_field_by_name(name)
          element = @browser.text_field(name:)
          return nil unless element.respond_to?(:exists?)

          element if element.exists?
        end
      end
    end
  end
end
