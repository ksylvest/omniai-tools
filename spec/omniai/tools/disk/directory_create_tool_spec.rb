# frozen_string_literal: true

RSpec.describe OmniAI::Tools::Disk::DirectoryCreateTool do
  subject(:tool) { described_class.new(driver:) }

  let(:driver) { OmniAI::Tools::Disk::BaseDriver.new(root:) }
  let(:root) { ROOT.join("spec", "fixtures", "project") }

  describe "#execute" do
    subject(:execute) { tool.execute(path: "./example") }

    it "creates a directory" do
      allow(driver).to receive(:directory_create)
      execute
      expect(driver).to have_received(:directory_create).with(path: "./example")
    end
  end
end
