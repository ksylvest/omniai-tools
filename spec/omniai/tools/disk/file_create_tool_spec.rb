# frozen_string_literal: true

RSpec.describe OmniAI::Tools::Disk::FileCreateTool do
  subject(:tool) { described_class.new(driver:) }

  let(:driver) { OmniAI::Tools::Disk::BaseDriver.new(root:) }
  let(:root) { ROOT.join("spec", "fixtures", "project") }

  describe "#execute" do
    subject(:execute) { tool.execute(path:) }

    let(:path) { "./README.md" }

    it "creates a file" do
      allow(driver).to receive(:file_create)
      execute
      expect(driver).to have_received(:file_create).with(path:)
    end
  end
end
