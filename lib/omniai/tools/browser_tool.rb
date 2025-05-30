# frozen_string_literal: true

module OmniAI
  module Tools
    # A tool for controller a browser.
    class BrowserTool < OmniAI::Tool
      module Action
        VISIT = "visit"
        PAGE_INSPECT = "page_inspect"
        UI_INSPECT = "ui_inspect"
        SELECTOR_INSPECT = "selector_inspect"
        BUTTON_CLICK = "button_click"
        LINK_CLICK = "link_click"
        ELEMENT_CLICK = "element_click"
        TEXT_FIELD_SET = "text_field_set"
      end

      ACTIONS = [
        Action::VISIT,
        Action::PAGE_INSPECT,
        Action::UI_INSPECT,
        Action::SELECTOR_INSPECT,
        Action::BUTTON_CLICK,
        Action::LINK_CLICK,
        Action::ELEMENT_CLICK,
        Action::TEXT_FIELD_SET,
      ].freeze

      description <<~TEXT
          Control a web browser to automate interactions with websites.

          1. `#{Action::VISIT}` - Navigate to a website
            Required: "action": "visit", "url": "[website URL]"

          2. `#{Action::PAGE_INSPECT} - Get page HTML or summary
            Required: "action": "page_inspect"
            Optional: "full_html": true/false (get full HTML vs summary, default: summary)

          3. `#{Action::UI_INSPECT}` - Find elements by text content
            Required: "action": "ui_inspect", "text_content": "[text to search for]"
            Optional:
            - "selector": "[CSS selector]" (search within specific container)
            - "context_size": [number] (parent elements to show, default: 2)

          4. `#{Action::SELECTOR_INSPECT} - Find elements by CSS selector
            Required: "action": "selector_inspect", "selector": "[CSS selector]"
            Optional: "context_size": [number] (parent elements to show, default: 2)

          5. `#{Action::BUTTON_CLICK}` - Click a button
            Required: "action": "button_click", "selector": "[button text or CSS selector]"

          6. `#{Action::LINK_CLICK}` - Click a link
            Required: "action": "link_click", "selector": "[link text or CSS selector]"

          7. `#{Action::ELEMENT_CLICK}` - Click any clickable element (div, span, etc.)
            Required: "action": "element_click", "selector": "[CSS selector, text content, ID, or XPath]"

          8. `#{Action::TEXT_FIELD_SET}` - Enter text in input fields/text areas
            Required: "action": "text_field_set", "selector": "[field CSS selector]", "value": "[text to enter]"

          9. `#{Action::SCREENSHOT}` - Take a screenshot of the page or specific element
            Required: "action": "screenshot"

          Examples:
        Visit a website
          {"action": "#{Action::VISIT}", "url": "https://example.com"}
        Get page summary
          {"action": "#{Action::PAGE_INSPECT}"}
        Get full page HTML
          {"action": "#{Action::PAGE_INSPECT}", "full_html": true}
        Find elements containing text
          {"action": "#{Action::UI_INSPECT}", "text_content": "Submit"}
        Find elements with context
          {"action": "#{Action::UI_INSPECT}", "text_content": "Login", "context_size": 3}
        Find elements by CSS selector
          {"action": "#{Action::SELECTOR_INSPECT}", "selector": ".button"}
        Find selector with context
          {"action": "#{Action::SELECTOR_INSPECT}", "selector": "h1", "context_size": 2}
        Click a button with specific text
          {"action": "#{Action::BUTTON_CLICK}", "selector": "Submit"}
        Click a link with specific text
          {"action": "#{Action::LINK_CLICK}", "selector": "Learn More"}
        Click element by CSS selector
          {"action": "#{Action::ELEMENT_CLICK}", "selector": ".wv-select__menu__option"}
        Click element by role attribute
          {"action": "#{Action::ELEMENT_CLICK}", "selector": "[role='listitem']"}
        Click element by text content
          {"action": "#{Action::ELEMENT_CLICK}", "selector": "Medical Evaluation Management"}
        Set text in an input field
          {"action": "#{Action::TEXT_FIELD_SET}", "selector": "#search", "value": "search query"}
        Take a full page screenshot
          {"action": "#{Action::SCREENSHOT}"}
      TEXT

      parameter :action, :string, enum: ACTIONS, description: <<~TEXT
        The browser action to perform. Options:
        * `#{Action::VISIT}`: Navigate to a website
        * `#{Action::PAGE_INSPECT}`: Get full HTML or summarized page information
        * `#{Action::UI_INSPECT}`: Find elements containing specific text
        * `#{Action::SELECTOR_INSPECT}`: Find elements matching CSS selectors
        * `#{Action::BUTTON_CLICK}`: Click a button element
        * `#{Action::LINK_CLICK}`: Click a link element
        * `#{Action::ELEMENT_CLICK}`: Click any clickable element
        * `#{Action::TEXT_FIELD_SET}`: Enter text in input fields or text areas
      TEXT

      parameter :url, :string, description: <<~TEXT
        The URL to visit. Required for the following actions:
        * `#{Action::VISIT}`
      TEXT

      parameter :selector, :string, description: <<~TEXT
        CSS selector, ID, or text content of the element. Required for the following actions:
        * `#{Action::SELECTOR_INSPECT}`
        * `#{Action::BUTTON_CLICK}`
        * `#{Action::LINK_CLICK}`
        * `#{Action::ELEMENT_CLICK}`
        * `#{Action::TEXT_FIELD_SET}`

        Optional for the following actions:
        * `#{Action::UI_INSPECT}` (search within specific container)
      TEXT

      parameter :value, :string, description: <<~TEXT
        The value to set in the text field. Required for the following actions:
        * `#{Action::TEXT_FIELD_SET}`
      TEXT

      parameter :context_size, :integer, description: <<~TEXT
        Number of parent elements to include in inspect results (default: 2). Optional for the following actions:
        * `#{Action::UI_INSPECT}`
        * `#{Action::SELECTOR_INSPECT}`
      TEXT

      parameter :full_html, :boolean, description: <<~TEXT
        Return the full HTML of the page instead of a summary. Optional for the following actions:
        * `#{Action::PAGE_INSPECT}`
      TEXT

      parameter :text_content, :string, description: <<~TEXT
        Search for elements containing this text. Required for the following actions:
        * `#{Action::UI_INSPECT}`
      TEXT

      required %i[action]

      # @param logger [Logger]
      # @param driver [OmniAI::Tools::Browser::BaseDriver]
      def initialize(logger:, driver:)
        super()
        @logger = logger
        @driver = driver
      end

      def cleanup!
        @driver.close
      end

      # @param action [String]
      # @param url [String, nil]
      # @param selector [String, nil]
      # @param value [String, nil]
      # @param context_size [Integer]
      # @param full_html [Boolean]
      # @param text_content [String, nil]
      #
      # @return [String]
      def execute(action:, url: nil, selector: nil, value: nil, context_size: 2, full_html: false, text_content: nil)
        case action.to_s.downcase
        when Action::VISIT
          require_param!(:url, url)
          visit_tool.execute(url:)
        when Action::PAGE_INSPECT
          if full_html
            page_inspect_tool.execute
          else
            page_inspect_tool.execute(summarize: true)
          end
        when Action::UI_INSPECT
          require_param!(:text_content, text_content)
          inspect_tool.execute(text_content:, selector:, context_size:)
        when Action::SELECTOR_INSPECT
          require_param!(:selector, selector)
          selector_inspect_tool.execute(selector:, context_size:)
        when Action::BUTTON_CLICK
          require_param!(:selector, selector)
          button_click_tool.execute(selector:)
        when Action::LINK_CLICK
          require_param!(:selector, selector)
          link_click_tool.execute(selector:)
        when Action::ELEMENT_CLICK
          require_param!(:selector, selector)
          element_click_tool.execute(selector:)
        when Action::TEXT_FIELD_SET
          require_param!(:selector, selector)
          require_param!(:value, value)
          text_field_area_set_tool.execute(selector:, text: value)
        when Action::SCREENSHOT
          page_screenshot_tool.execute
        else
          { error: "Unsupported action: #{action}. Supported actions are: #{ACTIONS.join(', ')}" }
        end
      end

    private

      # @param name [Symbol]
      # @param value [Object]
      #
      # @raise [ArgumentError]
      # @return [void]
      def require_param!(name, value)
        raise ArgumentError, "#{name} parameter is required for this action" if value.nil?
      end

      # @return [Browser::VisitTool]
      def visit_tool
        Browser::VisitTool.new(driver: @driver, logger: @logger)
      end

      # @return [Browser::PageInspectTool]
      def page_inspect_tool
        Browser::PageInspectTool.new(driver: @driver, logger: @logger)
      end

      # @return [Browser::UIInspectTool]
      def inspect_tool
        Browser::InspectTool.new(driver: @driver, logger: @logger)
      end

      # @return [Browser::SelectorInspectTool]
      def selector_inspect_tool
        Browser::SelectorInspectTool.new(driver: @driver, logger: @logger)
      end

      # @return [Browser::ButtonClickTool]
      def button_click_tool
        Browser::ButtonClickTool.new(driver: @driver, logger: @logger)
      end

      # @return [Browser::LinkClickTool]
      def link_click_tool
        Browser::LinkClickTool.new(driver: @driver, logger: @logger)
      end

      # @return [Browser::ElementClickTool]
      def element_click_tool
        Browser::ElementClickTool.new(driver: @driver, logger: @logger)
      end

      # @return [Browser::TextFieldAreaSetTool]
      def text_field_area_set_tool
        Browser::TextFieldAreaSetTool.new(driver: @driver, logger: @logger)
      end

      # @return [Browser::PageScreenshotTool]
      def page_screenshot_tool
        Browser::PageScreenshotTool.new(driver: @driver, logger: @logger)
      end
    end
  end
end
