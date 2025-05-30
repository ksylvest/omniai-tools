# frozen_string_literal: true

require "simplecov"

Bundler.require(:default)

SimpleCov.start do
  enable_coverage :branch
end

require "omniai/tools"

ROOT = Pathname(__dir__).join("..")

RSpec.configure do |config|
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
