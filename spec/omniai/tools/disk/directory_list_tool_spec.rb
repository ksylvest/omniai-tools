# frozen_string_literal: true

RSpec.describe OmniAI::Tools::Disk::DirectoryListTool do
  subject(:tool) { described_class.new(driver:) }

  let(:driver) { OmniAI::Tools::Disk::BaseDriver.new(root:) }
  let(:root) { ROOT.join("spec", "fixtures", "project") }

  describe "#execute" do
    subject(:execute) { tool.execute }

    it "lists a directory" do
      allow(driver).to receive(:directory_list).and_return("📄 ./Dockerfile (0 bytes)")
      expect(execute).to eql("📄 ./Dockerfile (0 bytes)")
      expect(driver).to have_received(:directory_list)
    end
  end
end
