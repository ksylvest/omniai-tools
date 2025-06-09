# frozen_string_literal: true

RSpec.describe OmniAI::Tools::Disk::FileReadTool do
  subject(:tool) { described_class.new(driver:) }

  let(:driver) { OmniAI::Tools::Disk::BaseDriver.new(root:) }
  let(:root) { ROOT.join("spec", "fixtures", "project") }

  describe "#execute" do
    subject(:execute) { tool.execute(path: "./README.md") }

    it "reads a file" do
      allow(driver).to receive(:file_read).and_return("Hello World")
      execute
      expect(execute).to eql("Hello World")
    end
  end
end
