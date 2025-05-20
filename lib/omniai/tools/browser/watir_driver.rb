# frozen_string_literal: true

require "watir"

module OmniAI
  module Tools
    module Browser
      # @example
      #   driver = OmniAI::Tools::Browser::WatirDriver.new
      #   driver.visit("https://example.com")
      #   driver.click(id: "submit-button")
      class WatirDriver < BaseDriver
        def initialize(logger: Logger.new(IO::NULL), browser: Watir::Browser.new(:chrome))
          super(logger:)
          @browser = browser
        end

        def close
          @browser.close
        end

        # @return [String]
        def url
          @browser.url
        end

        # @return [String]
        def title
          @browser.title
        end

        # @return [String]
        def html
          @browser.html
        end

        # @param url [String]
        def goto(url:)
          @browser.goto(url)

          { status: :ok }
        end

        # @yield [file]
        # @yieldparam file [File]
        def screenshot
          tempfile = Tempfile.new(["screenshot", ".png"])
          @browser.screenshot.save(tempfile.path)

          yield File.open(tempfile.path, "rb")
        ensure
          tempfile&.close
          tempfile&.unlink
        end

        # @param selector [String]
        # @param text [String]
        #
        # @return [Hash]
        def fill_in(selector:, text:)
          element = find_field(selector)

          return { status: :error, message: "unknown selector=#{selector.inspect}" } if element.nil?

          element.set(text)

          { status: :ok }
        end

        # @param selector [String]
        #
        # @return [Hash]
        def button_click(selector:)
          element = find_button(selector)

          return { status: error, message: "unknown selector=#{selector.inspect}" } if element.nil?

          element.click

          { status: :ok }
        end

        # @param selector [String]
        #
        # @return [Hash]
        def link_click(selector:)
          element = find_link(selector)

          return { status: :error, message: "unknown selector=#{selector.inspect}" } if element.nil?

          element.click

          { status: :ok }
        end

        # @param selector [String]
        #
        # @return [Hash]
        def element_click(selector:)
          element = find_element(selector)

          return { status: :error, message: "unknown selector=#{selector.inspect}" } if element.nil?

          element.click

          { status: :ok }
        rescue TimeoutError => e
          { status: :error, message: e.message }
        end

      protected

        def wait_for_element
          Watir::Wait.until(timeout: TIMEOUT) do
            element = yield
            element if element&.visible?
          end
        rescue Watir::Wait::TimeoutError
          nil
        end

        # @param selector [String]
        #
        # @return [Watir::TextField, Watir::TextArea, nil]
        def find_field(selector)
          wait_for_element do
            find_text_area_or_field_by(id: selector) ||
              find_text_area_or_field_by(name: selector) ||
              find_text_area_or_field_by(placeholder: selector) ||
              find_text_area_or_field_by(class: selector) ||
              find_text_area_or_field_by(css: selector)
          end
        end

        # @param selector [String]
        #
        # @return [Watir::TextArea, Watir::TextField, nil]
        def find_text_area_or_field_by(selector)
          find_text_field_by(selector) || find_text_area_by(selector)
        end

        # @param selector [String]
        #
        # @return [Watir::Button, nil]
        def find_button(selector)
          wait_for_element do
            find_button_by(text: selector) || find_button_by(id: selector)
          end
        end

        # @param selector [String]
        #
        # @return [Watir::Button, nil]
        def find_link(selector)
          wait_for_element do
            find_link_by(text: selector) || find_link_by(href: selector) || find_link_by(id: selector)
          end
        end

        # @param selector [Hash] A hash with one of the following
        #
        # @return [Watir::Element, nil]
        def find_element(selector)
          wait_for_element do
            find_element_by(css: selector) ||
              find_element_by(text: selector) ||
              find_element_by(id: selector) ||
              find_element_by(xpath: selector)
          end
        end

        # @param selector [Hash]
        #
        # @return [Watir::TextArea, nil]
        def find_text_area_by(selector)
          element = @browser.textarea(selector)
          return unless element.respond_to?(:exists?)

          element if element.exists?
        end

        # @param selector [Hash]
        #
        # @return [Watir::TextField, nil]
        def find_text_field_by(selector)
          element = @browser.text_field(selector)
          return unless element.respond_to?(:exists?)

          element if element.exists?
        end

        # @param selector [String] CSS selector to find the element
        #
        # @return [Watir::Element, nil]
        def find_element_by(selector)
          element = @browser.element(selector)
          return nil unless element.respond_to?(:exists?)

          element if element.exists?
        end

        # @param selector [Hash]
        #
        # @return [Watir::Anchor, nil]
        def find_link_by(selector)
          element = @browser.link(selector)
          return unless element.respond_to?(:exists?)

          element if element.exists?
        end

        # @param selector [Hash]
        #
        # @return [Watir::Button, nil]
        def find_button_by(selector)
          element = @browser.button(selector)
          return unless element.respond_to?(:exists?)

          element if element.exists?
        end
      end
    end
  end
end
