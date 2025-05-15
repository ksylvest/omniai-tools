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
          @logger.info("#{self.class.name}##{__method__} selector=#{selector.inspect} text=#{text.inspect}")

          element = find(id: selector) || find(name: selector)

          return { error: "unknown selector=#{selector}" } if element.nil?

          element.set(text)
        end

      protected

        # @param selector [Hash]
        #
        # @return [Watir::TextArea, Watir::TextField, nil]
        def find(selector)
          find_text_area(selector) || find_text_field(selector)
        end

        # @param selector [Hash]
        #
        # @return [Watir::TextArea, nil]
        def find_text_area(selector)
          element = @browser.textarea(selector)
          element if element.exists?
        end

        # @param selector [Hash]
        #
        # @return [Watir::TextField, nil]
        def find_text_field(selector)
          element = @browser.text_field(selector)
          element if element.exists?
        end
      end
    end
  end
end
