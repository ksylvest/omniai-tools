# frozen_string_literal: true

require "nokogiri"

module OmniAI
  module Tools
    module Browser
      # A browser automation tool for viewing the full HTML of the page.
      class PageInspectTool < BaseTool
        include InspectUtils

        description "A browser automation tool for viewing the full HTML of the current page."

        parameter :summarize, :boolean, description: "If true, returns a summary instead of full HTML"

        def execute(summarize: false)
          @logger.info("#{self.class.name}##{__method__}")

          doc = cleaned_document(html: @driver.html)

          if summarize
            PageInspect::HtmlSummarizer.summarize_interactive_elements(doc)
          else
            doc.to_html
          end
        end
      end
    end
  end
end
