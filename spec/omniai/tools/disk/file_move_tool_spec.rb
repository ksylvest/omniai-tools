# frozen_string_literal: true

RSpec.describe OmniAI::Tools::Disk::FileMoveTool do
  subject(:tool) { described_class.new(driver:) }

  let(:driver) { OmniAI::Tools::Disk::BaseDriver.new(root:) }
  let(:root) { ROOT.join("spec", "fixtures", "project") }

  describe "#execute" do
    subject(:execute) { tool.execute(path:, destination:) }

    let(:path) { "./README.txt" }
    let(:destination) { "./README.md" }

    it "moves a file" do
      allow(driver).to receive(:file_move)
      execute
      expect(driver).to have_received(:file_move).with(path:, destination:)
    end
  end
end
