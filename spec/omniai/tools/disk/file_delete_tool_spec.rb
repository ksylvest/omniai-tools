# frozen_string_literal: true

RSpec.describe OmniAI::Tools::Disk::FileDeleteTool do
  subject(:tool) { described_class.new(root:) }

  let(:root) do
    dir = Dir.mktmpdir
    FileUtils.touch(File.join(dir, "README.md"))
    dir
  end

  around do |example|
    example.run
  ensure
    FileUtils.remove_entry(root)
  end

  describe "#execute" do
    subject(:execute) { tool.execute(path: "./README.md") }

    it "deletes a file" do
      expect { execute }.to change { File.exist?(Pathname(root).join("README.md")) }
        .from(true)
        .to(false)
    end
  end
end
