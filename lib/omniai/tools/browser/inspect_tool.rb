# frozen_string_literal: true

require "nokogiri"

module OmniAI
  module Tools
    module Browser
      # @example
      #   browser = Watir::Browser.new(:chrome)
      #   tool = OmniAI::Tools::Browser::InspectTool.new(browser:)
      #   tool.execute
      class InspectTool < BaseTool
        description "A browser automation tool for viewing the HTML for the browser."

        # @return [String]
        def execute
          @logger.info("#{self.class.name}##{__method__}")

          html = @browser.html
          doc = Nokogiri::HTML(html)

          doc.css("link").each(&:remove)
          doc.css("style").each(&:remove)
          doc.css("script").each(&:remove)

          doc.to_html
        end
      end
    end
  end
end
