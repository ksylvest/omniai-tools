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

        # @param selector [String] The ID or text of the link to interact with.
        def execute(selector:)
          @logger.info("#{self.class.name}##{__method__} selector=#{selector.inspect}")

          element = find_by_text(selector) || find_by_value(selector) || find_by_id(selector)

          return { error: "unknown selector=#{selector}" } if element.nil?

          element.click

          # Return a meaningful string that includes information about the selector
          "Successfully clicked link with selector: #{selector}"
        end

      protected

        # @param text [String] The text of the link to find
        # @return [Watir::Anchor, nil]
        def find_by_text(text)
          element = @browser.a(text:)
          return nil unless element.respond_to?(:exists?)

          element if element.exists?
        end

        # @param value [String] The value of the link to find
        # @return [Watir::Anchor, nil]
        def find_by_value(value)
          element = @browser.a(value:)
          return nil unless element.respond_to?(:exists?)

          element if element.exists?
        end

        # @param id [String] The ID of the link to find
        # @return [Watir::Anchor, nil]
        def find_by_id(id)
          element = @browser.a(id:)
          return nil unless element.respond_to?(:exists?)

          element if element.exists?
        end
      end
    end
  end
end
