# frozen_string_literal: true

RSpec.describe OmniAI::Tools::Disk::FileCreateTool do
  subject(:tool) { described_class.new(root:) }

  let(:root) do
    Dir.mktmpdir
  end

  around do |example|
    example.run
  ensure
    FileUtils.remove_entry(root)
  end

  describe "#execute" do
    subject(:execute) { tool.execute(path: "./README.md") }

    it "creates a file" do
      expect { execute }.to change { File.exist?(Pathname(root).join("README.md")) }
        .from(false)
        .to(true)
    end
  end
end
