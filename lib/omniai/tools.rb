# frozen_string_literal: true

require "zeitwerk"
require "omniai"

loader = Zeitwerk::Loader.for_gem
loader.push_dir(__dir__, namespace: OmniAI)
loader.setup

module OmniAI
  module Tools
    class Error < StandardError; end
  end
end
