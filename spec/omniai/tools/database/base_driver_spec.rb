# frozen_string_literal: true

require "omniai/tools/database/base_driver"

RSpec.describe OmniAI::Tools::Database::BaseDriver do
  subject(:driver) { described_class.new }

  describe "#perform" do
    it "raises NotImplementedError" do
      expect { driver.perform(statement: "SELECT * FROM people") }.to raise_error(NotImplementedError)
    end
  end
end
