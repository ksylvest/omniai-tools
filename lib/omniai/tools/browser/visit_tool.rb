# frozen_string_literal: true

module OmniAI
  module Tools
    module Browser
      # @example
      #   driver = Selenium::WebDriver.for :chrome
      #   tool = OmniAI::Tools::Browser::VisitTool.new(driver:)
      #   tool.execute(to: "https://news.ycombinator.com")
      class VisitTool < BaseTool
        description "A browser automation tool for navigating to a specific URL."

        parameter :url, :string, description: "A URL (e.g. https://news.ycombinator.com)."

        required %i[url]

        # @param url [String] A URL (e.g. https://news.ycombinator.com).
        def execute(url:)
          @logger.info("#{self.class.name}##{__method__} url=#{url.inspect}")

          @driver.goto(url:)
        end
      end
    end
  end
end
