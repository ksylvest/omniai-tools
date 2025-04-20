# frozen_string_literal: true

RSpec.describe OmniAI::Tools::Disk::SummaryTool do
  subject(:tool) { described_class.new(root:) }

  let(:root) { ROOT.join("spec", "fixtures", "project") }

  describe "#execute" do
    subject(:execute) { tool.execute }

    it "returns a summary of the project contents" do
      expect(execute).to eql(<<~TEXT.strip)
        📄 ./Dockerfile (178 bytes)
        📄 ./Gemfile (88 bytes)
        📄 ./compose.yml (70 bytes)
        📁 ./lib/
        📄 ./lib/greet.rb (85 bytes)
      TEXT
    end
  end
end
