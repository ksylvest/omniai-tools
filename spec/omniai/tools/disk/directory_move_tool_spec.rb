# frozen_string_literal: true

RSpec.describe OmniAI::Tools::Disk::DirectoryMoveTool do
  subject(:tool) { described_class.new(driver:) }

  let(:driver) { OmniAI::Tools::Disk::BaseDriver.new(root:) }
  let(:root) { ROOT.join("spec", "fixtures", "project") }

  describe "#execute" do
    subject(:execute) { tool.execute(path:, destination:) }

    let(:path) { "./source" }
    let(:destination) { "./destination" }

    it "moves a directory" do
      allow(driver).to receive(:directory_move)
      execute
      expect(driver).to have_received(:directory_move).with(path:, destination:)
    end
  end
end
