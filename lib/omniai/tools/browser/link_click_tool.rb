# frozen_string_literal: true

require "sqlite3"

module OmniAI
  module Tools
    module Browser
      # @example
      #   browser = Watir::Browser.new(:chrome)
      #   tool = OmniAI::Tools::Browser::VisitTool.new(browser:)
      #   tool.click_link(selector: "link_id")
      class LinkClickTool < BaseTool
        description "A browser automation tool for clicking a specific link."

        parameter :selector, :string, description: "The ID or text of the link to interact with."

        # @param to [String] The ID or text of the link to interact with.
        def execute(selector:)
          @logger.info("#{self.class.name}##{__method__} selector=#{selector.inspect}")

          element = find(text: selector) || find(value: selector) || find(id: selector)

          return { error: "unknown selector=#{selector}" } if element.nil?

          element.click
        end

      protected

        # @return [Watir::Anchor, nil]
        def find(selector)
          element = @browser.a(selector)
          element if element.exists?
        end
      end
    end
  end
end
