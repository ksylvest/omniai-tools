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

          @driver.fill_in(selector:, text:)
        end
      end
    end
  end
end
