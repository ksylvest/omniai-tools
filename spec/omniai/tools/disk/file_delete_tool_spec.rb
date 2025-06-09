# frozen_string_literal: true

RSpec.describe OmniAI::Tools::Disk::FileDeleteTool do
  subject(:tool) { described_class.new(driver:) }

  let(:driver) { OmniAI::Tools::Disk::BaseDriver.new(root:) }
  let(:root) { ROOT.join("spec", "fixtures", "project") }

  describe "#execute" do
    subject(:execute) { tool.execute(path:) }

    let(:path) { "./README.md" }

    it "deletes a file" do
      allow(driver).to receive(:file_delete)
      execute
      expect(driver).to have_received(:file_delete).with(path:)
    end
  end
end
