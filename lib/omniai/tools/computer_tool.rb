# frozen_string_literal: true

module OmniAI
  module Tools
    # A tool for interacting with a computer. Be careful with using as it can perform actions on your computer!
    #
    # @example
    #   computer = OmniAI::Tools::Computer::MacTool.new
    #   computer.display # { "width": 2560, "height": 1440, "scale": 1 }
    #   computer.screenshot
    class ComputerTool < OmniAI::Tool
      description "A tool for interacting with a computer."

      module Action
        KEY = "key" # press a key
        HOLD_KEY = "hold_key" # hold a key
        MOUSE_POSITION = "mouse_position" # get the current (x, y) pixel coordinate of the cursor on the screen
        MOUSE_MOVE = "mouse_move" # move the cursor to a specific (x, y) pixel coordinate on the screen
        MOUSE_CLICK = "mouse_click" # click at a specific x / y coordinate
        MOUSE_DOWN = "mouse_down" # press the mouse button down
        MOUSE_DRAG = "mouse_drag" # drag the mouse to a specific x / y coordinate
        MOUSE_UP = "mouse_up" # release the mouse button
        MOUSE_DOUBLE_CLICK = "mouse_double_click" # double click at a specific x / y coordinate
        MOUSE_TRIPLE_CLICK = "mouse_triple_click" # triple click at a specific x / y coordinate
        TYPE = "type" # type a string
        SCROLL = "scroll"
        WAIT = "wait"
      end

      module MouseButton
        LEFT = "left"
        MIDDLE = "middle"
        RIGHT = "right"
      end

      module ScrollDirection
        UP = "up"
        DOWN = "down"
        LEFT = "left"
        RIGHT = "right"
      end

      ACTIONS = [
        Action::KEY,
        Action::HOLD_KEY,
        Action::MOUSE_POSITION,
        Action::MOUSE_MOVE,
        Action::MOUSE_CLICK,
        Action::MOUSE_DOWN,
        Action::MOUSE_DRAG,
        Action::MOUSE_UP,
        Action::TYPE,
        Action::SCROLL,
        Action::WAIT,
      ].freeze

      MOUSE_BUTTON_OPTIONS = [
        MouseButton::LEFT,
        MouseButton::MIDDLE,
        MouseButton::RIGHT,
      ].freeze

      SCROLL_DIRECTION_OPTIONS = [
        ScrollDirection::UP,
        ScrollDirection::DOWN,
        ScrollDirection::LEFT,
        ScrollDirection::RIGHT,
      ].freeze

      parameter :action, :string, enum: ACTIONS, description: <<~TEXT
        Options:
        * `#{Action::KEY}`: Press a single key / combination of keys on the keyboard:
          - supports xdotool's `key` syntax (e.g. "alt+Tab", "Return", "ctrl+s", etc)
        * `#{Action::HOLD_KEY}`: Hold down a key or multiple keys for a specified duration (in seconds):
          - supports xdotool's `key` syntax (e.g. "alt+Tab", "Return", "ctrl+s", etc)
        * `#{Action::MOUSE_POSITION}`: Get the current (x,y) pixel coordinate of the cursor on the screen.
        * `#{Action::MOUSE_MOVE}`: Move the cursor to a specified (x,y) pixel coordinate on the screen.
        * `#{Action::MOUSE_CLICK}`: Click the mouse button at the specified (x,y) pixel coordinate on the screen.
        * `#{Action::MOUSE_DOUBLE_CLICK}`: Double click at the specified (x,y) pixel coordinate on the screen.
        * `#{Action::MOUSE_TRIPLE_CLICK}`: Triple click at the specified (x,y) pixel coordinate on the screen.
        * `#{Action::MOUSE_DOWN}`: Press the mouse button at the specified (x,y) pixel coordinate on the screen.
        * `#{Action::MOUSE_DRAG}`: Click and drag the cursor to a specified (x, y) pixel coordinate on the screen.
        * `#{Action::MOUSE_UP}`: Release the mouse button at the specified (x,y) pixel coordinate on the screen.
        * `#{Action::TYPE}`: Type a string of text on the keyboard.
        * `#{Action::SCROLL}`: Scroll the screen in a specified direction by a specified amount of clicks of the scroll wheel.
        * `#{Action::WAIT}`: Wait for a specified duration (in seconds).
      TEXT

      parameter :coordinate, :object, properties: {
        x: OmniAI::Schema.integer(description: "The x position in pixels"),
        y: OmniAI::Schema.integer(description: "The y position in pixels"),
      }, required: %i[x y], description: <<~TEXT
        An (x,y) coordinate. Required for the following actions:
        * `#{Action::MOUSE_MOVE}`
        * `#{Action::MOUSE_CLICK}`
        * `#{Action::MOUSE_DOWN}`
        * `#{Action::MOUSE_DRAG}`
        * `#{Action::MOUSE_UP}`
        * `#{Action::MOUSE_DOUBLE_CLICK}`
        * `#{Action::MOUSE_TRIPLE_CLICK}`
      TEXT

      parameter :text, :string, description: <<~TEXT
        The text to type. Required for the following actions:
        * `#{Action::KEY}`
        * `#{Action::HOLD_KEY}`
        * `#{Action::TYPE}`
      TEXT

      parameter :duration, :integer, description: <<~TEXT
        A duration in seconds. Required for the following actions:
        * `#{Action::HOLD_KEY}`
        * `#{Action::WAIT}`
      TEXT

      parameter :mouse_button, :string, enum: MOUSE_BUTTON_OPTIONS, description: <<~TEXT
        The mouse button to use. Required for the following actions:
        * `#{Action::MOUSE_CLICK}`
        * `#{Action::MOUSE_DOWN}`
        * `#{Action::MOUSE_DRAG}`
        * `#{Action::MOUSE_UP}`
        * `#{Action::MOUSE_DOUBLE_CLICK}`
        * `#{Action::MOUSE_TRIPLE_CLICK}`
      TEXT

      parameter :scroll_direction, :string, enum: SCROLL_DIRECTION_OPTIONS, description: <<~TEXT
        The direction to scroll. Required for the following actions:
        * `#{Action::SCROLL}`
      TEXT

      parameter :scroll_amount, :integer, description: <<~TEXT
        The amount of clicks to scroll. Required for the following actions:
        * `#{Action::SCROLL}`
      TEXT

      required %i[action]

      # @param driver [Computer::Driver]
      def initialize(driver:, logger: Logger.new(IO::NULL))
        @driver = driver
        @logger = logger
        super()
      end

      # @param action [String]
      # @param coordinate [Hash<{ width: Integer, height: Integer }>] the (x,y) coordinate
      # @param text [String]
      # @param duration [Integer] the duration in seconds
      # @param mouse_button [String] e.g. "left", "middle", "right"
      # @param scroll_direction [String] e.g. "up", "down", "left", "right"
      # @param scroll_amount [Integer] the amount of clicks to scroll
      def execute(
        action:,
        coordinate: nil,
        text: nil,
        duration: nil,
        mouse_button: nil,
        scroll_direction: nil,
        scroll_amount: nil
      )
        @logger.info({
          action:,
          coordinate:,
          text:,
          duration:,
          mouse_button:,
          scroll_direction:,
          scroll_amount:,
        }.compact.map { |key, value| "#{key}=#{value.inspect}" }.join(" "))

        case action
        when Action::KEY then @driver.key(text:)
        when Action::HOLD_KEY then @driver.hold_key(text:, duration:)
        when Action::MOUSE_POSITION then @driver.mouse_position
        when Action::MOUSE_MOVE then @driver.mouse_move(coordinate:)
        when Action::MOUSE_CLICK then @driver.mouse_click(coordinate:, button: mouse_button)
        when Action::MOUSE_DOUBLE_CLICK then @driver.mouse_double_click(coordinate:, button: mouse_button)
        when Action::MOUSE_TRIPLE_CLICK then @driver.mouse_triple_click(coordinate:, button: mouse_button)
        when Action::MOUSE_DOWN then @driver.mouse_down(coordinate:, button: mouse_button)
        when Action::MOUSE_UP then @driver.mouse_up(coordinate:, button: mouse_button)
        when Action::MOUSE_DRAG then @driver.mouse_drag(coordinate:, button: mouse_button)
        when Action::TYPE then @driver.type(text:)
        when Action::SCROLL then @driver.scroll(amount: scroll_amount, direction: scroll_direction)
        when Action::WAIT then @driver.wait(duration:)
        end
      end
    end
  end
end
