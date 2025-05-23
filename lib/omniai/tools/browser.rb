# frozen_string_literal: true

module OmniAI
  module Tools
    # This module contains browser automation tools
    module Browser
    end
  end
end

require_relative "browser/base_tool"
require_relative "browser/inspect_utils"
require_relative "browser/element_formatter"
require_relative "browser/nearby_element_detector"
require_relative "browser/ui_inspect_tool"
