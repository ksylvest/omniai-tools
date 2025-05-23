# frozen_string_literal: true

require "sqlite3"

module OmniAI
  module Tools
    module Computer
      # A tool for interacting with a computer. Be careful with using as it can perform actions on your computer!
      #
      # @example
      #   driver = OmniAI::Tools::Computer::MacDriver.new
      #   tool = OmniAI::Tools::Computer::DesktopTool.new(driver:)
      #   tool.execute(action: "screenshot")
      class BaseDriver
        # @param display_width [Integer] the width of the display in pixels
        # @param display_height [Integer] the height of the display in pixels
        # @param display_scale [Integer] the scale of the display
        # @param display_number [Integer] the display number
        def initialize(display_width:, display_height:, display_scale:, display_number:)
          @display_width = display_width
          @display_height = display_height
          @display_scale = display_scale
          @display_number = display_number
        end

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
          raise NotImplementedError, "#{self.class.name}##{__method__} undefined"
        end

        # @param coordinate [Hash<{ x: Integer, y: Integer }>]
        # @param button [String] e.g. "left", "middle", "right"
        def mouse_click(coordinate:, button:)
          raise NotImplementedError, "#{self.class.name}##{__method__} undefined"
        end

        # @param coordinate [Hash<{ x: Integer, y: Integer }>]
        # @param button [String] e.g. "left", "middle", "right"
        def mouse_move(coordinate:, button:)
          raise NotImplementedError, "#{self.class.name}##{__method__} undefined"
        end

        # @param coordinate [Hash<{ x: Integer, y: Integer }>]
        # @param button [String] e.g. "left", "middle", "right"
        def mouse_down(coordinate:, button:)
          raise NotImplementedError, "#{self.class.name}##{__method__} undefined"
        end

        # @param coordinate [Hash<{ x: Integer, y: Integer }>]
        # @param button [String] e.g. "left", "middle", "right"
        def mouse_up(coordinate:, button:)
          raise NotImplementedError, "#{self.class.name}##{__method__} undefined"
        end

        # @param coordinate [Hash<{ x: Integer, y: Integer }>]
        # @param button [String] e.g. "left", "middle", "right"
        def mouse_drag(coordinate:, button:)
          raise NotImplementedError, "#{self.class.name}##{__method__} undefined"
        end

        # @param coordinate [Hash<{ x: Integer, y: Integer }>]
        # @param button [String] e.g. "left", "middle", "right"
        def mouse_double_click(coordinate:, button:)
          raise NotImplementedError, "#{self.class.name}##{__method__} undefined"
        end

        # @param coordinate [Hash<{ x: Integer, y: Integer }>]
        # @param button [String] e.g. "left", "middle", "right"
        def mouse_tripple_click(coordinate:, button:)
          raise NotImplementedError, "#{self.class.name}##{__method__} undefined"
        end

        # @param text [String]
        def type(text:)
          raise NotImplementedError, "#{self.class.name}##{__method__} undefined"
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

        # @return [String]
        def screenshot
          raise NotImplementedError, "#{self.class.name}##{__method__} undefined"
        end

        # @return [Hash<{ width: Integer, height: Integer }>]
        def display_bounds
          raise NotImplementedError, "#{self.class.name}##{__method__} undefined"
        end
      end
    end
  end
end
