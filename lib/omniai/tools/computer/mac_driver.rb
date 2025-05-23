# frozen_string_literal: true

require "macos"

module OmniAI
  module Tools
    module Computer
      # A driver for interacting with a Mac. Be careful with using as it can perform actions on your computer!
      class MacDriver
        DEFAULT_MOUSE_BUTTON = "left"

        # @param text [String]
        def key(text:)
          raise NotImplementedError, "#{self.class.name}##{__method__} undefined"
        end

        # @param text [String]
        # @param duration [Integer]
        def hold_key(text:, duration:)
          raise NotImplementedError, "#{self.class.name}##{__method__} undefined"
        end

        # @return [Hash<{ x: Integer, y: Integer }>]
        def mouse_position
          position = MacOS.mouse.position
          x = position.x
          y = position.y

          {
            x:,
            y:,
          }
        end

        def mouse_move(coordinate:)
          x = coordinate[:x]
          y = coordinate[:y]

          MacOS.mouse.move(x:, y:)
        end

        # @param coordinate [Hash<{ x: Integer, y: Integer }>]
        # @param button [String] e.g. "left", "middle", "right"
        def mouse_click(coordinate:, button:)
          x = coordinate[:x]
          y = coordinate[:y]

          case button
          when "left" then MacOS.mouse.left_click(x:, y:)
          when "middle" then MacOS.mouse.middle_click(x:, y:)
          when "right" then MacOS.mouse.right_click(x:, y:)
          end
        end

        # @param coordinate [Hash<{ x: Integer, y: Integer }>]
        def mouse_down(coordinate:, button: DEFAULT_MOUSE_BUTTON)
          x = coordinate[:x]
          y = coordinate[:y]

          case button
          when "left" then MacOS.mouse.left_down(x:, y:)
          when "middle" then MacOS.mouse.middle_down(x:, y:)
          when "right" then MacOS.mouse.right_down(x:, y:)
          end
        end

        # @param coordinate [Hash<{ x: Integer, y: Integer }>]
        # @param button [String] e.g. "left", "middle", "right"
        def mouse_up(coordinate:, button: DEFAULT_MOUSE_BUTTON)
          x = coordinate[:x]
          y = coordinate[:y]

          case button
          when "left" then MacOS.mouse.left_up(x:, y:)
          when "middle" then the MacOS.mouse.middle_up(x:, y:)
          when "right" then MacOS.mouse.right_up(x:, y:)
          end
        end

        # @param coordinate [Hash<{ x: Integer, y: Integer }>]
        # @param button [String] e.g. "left", "middle", "right"
        def mouse_drag(coordinate:, button: DEFAULT_MOUSE_BUTTON)
          mouse_down(coordinate: mouse_position, button:)
          mouse_move(coordinate:, button:)
          mouse_up(coordinate:, button:)
        end

        # @param text [String]
        def type(text:)
          raise NotImplementedError, "#{self.class.name}##{__method__} undefined"
        end

        # @param coordinate [Hash<{ x: Integer, y: Integer }>]
        # @param button [String] e.g. "left", "middle", "right"
        def mouse_double_click(coordinate:, button: DEFAULT_MOUSE_BUTTON)
          2.times { mouse_click(coordinate:, button:) }
        end

        # @param coordinate [Hash<{ x: Integer, y: Integer }>]
        # @param button [String] e.g. "left", "middle", "right"
        def mouse_triple_click(coordinate:, button: DEFAULT_MOUSE_BUTTON)
          3.times { mouse_click(coordinate:, button:) }
        end

        # @param amount [Integer]
        # @param direction [String] e.g. "up", "down", "left", "right"
        def scroll(amount:, direction:)
          raise NotImplementedError, "#{self.class.name}##{__method__} undefined"
        end

        # @param duration [Integer]
        def wait(duration:)
          raise NotImplementedError, "#{self.class.name}##{__method__} undefined"
        end

        def screenshot
          MacOS.display.screenshot do |tempfile|
            "data:#{@type};base64,#{Base64.strict_encode64(tempfile.read)}"
          end
        end

        # @return [Hash<{ width: Integer, height: Integer }>]
        def display_bounds
          bounds = MacOS.display.bounds

          {
            width: bounds.width,
            height: bounds.height,
          }
        end
      end
    end
  end
end
