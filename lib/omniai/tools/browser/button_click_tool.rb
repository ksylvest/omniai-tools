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

        # @param to [String] The URL to navigate to.
        def execute(selector:)
          @logger.info("#{self.class.name}##{__method__} selector=#{selector.inspect}")

          element = find(text: selector) || find(id: selector)

          return { error: "unknown selector=#{selector}" } if element.nil?

          element.click
        end

      protected

        # @return [Watir::Anchor, nil]
        def find(selector)
          element = @browser.button(selector)
          element if element.exists?
        end
      end
    end
  end
end
