# frozen_string_literal: true

RSpec.describe OmniAI::Tools::Disk::FileReplaceTool do
  subject(:tool) { described_class.new(driver:) }

  let(:driver) { OmniAI::Tools::Disk::BaseDriver.new(root:) }
  let(:root) { ROOT.join("spec", "fixtures", "project") }

  describe "#execute" do
    subject(:execute) { tool.execute(old_text:, new_text:, path:) }

    let(:old_text) { "George" }
    let(:new_text) { "Ringo" }
    let(:path) { "./README.md" }

    it "replaces the text 'George' with the text 'Ringo" do
      allow(driver).to receive(:file_replace)
      execute
      expect(driver).to have_received(:file_replace).with(old_text:, new_text:, path:)
    end
  end
end
