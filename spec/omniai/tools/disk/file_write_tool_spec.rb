# frozen_string_literal: true

RSpec.describe OmniAI::Tools::Disk::FileWriteTool do
  subject(:tool) { described_class.new(driver:) }

  let(:driver) { OmniAI::Tools::Disk::BaseDriver.new(root:) }
  let(:root) { ROOT.join("spec", "fixtures", "project") }

  describe "#execute" do
    subject(:execute) { tool.execute(path:, text:) }

    let(:path) { "./README.md" }
    let(:text) { "Hello World" }

    it "writes a file" do
      allow(driver).to receive(:file_write)
      execute
      expect(driver).to have_received(:file_write).with(path:, text:)
    end
  end
end
