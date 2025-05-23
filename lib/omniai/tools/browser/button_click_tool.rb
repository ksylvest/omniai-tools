# frozen_string_literal: true

require "sqlite3"

module OmniAI
  module Tools
    module Browser
      # @example
      #   browser = Watir::Browser.new(:chrome)
      #   tool = OmniAI::Tools::Browser::VisitTool.new(browser:)
      #   tool.click_link(selector: "link_id")
      class ButtonClickTool < BaseTool
        description "A browser automation tool for clicking a specific button."

        parameter :selector, :string, description: "The ID or text of the button to interact with."

        required %i[selector]

        # @param selector [String] The ID or text of the button to interact with.
        def execute(selector:)
          @logger.info("#{self.class.name}##{__method__} selector=#{selector.inspect}")

          element = find_by_text(selector) || find_by_id(selector)

          return { error: "unknown selector=#{selector}" } if element.nil?

          element.click

          # Return a meaningful string that includes information about the selector
          "Successfully clicked button with selector: #{selector}"
        end

      protected

        # @param text [String] The text of the button to find
        # @return [Watir::Button, nil]
        def find_by_text(text)
          element = @browser.button(text:)
          return nil unless element.respond_to?(:exists?)

          element if element.exists?
        end

        # @param id [String] The ID of the button to find
        # @return [Watir::Button, nil]
        def find_by_id(id)
          element = @browser.button(id:)
          return nil unless element.respond_to?(:exists?)

          element if element.exists?
        end
      end
    end
  end
end
