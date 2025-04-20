# frozen_string_literal: true

RSpec.describe OmniAI::Tools::Disk::FileMoveTool do
  subject(:tool) { described_class.new(root:) }

  let(:root) do
    dir = Dir.mktmpdir
    FileUtils.touch(File.join(dir, "README.txt"))
    dir
  end

  around do |example|
    example.run
  ensure
    FileUtils.remove_entry(root)
  end

  describe "#execute" do
    subject(:execute) do
      tool.execute(
        old_path: "./README.txt",
        new_path: "./README.md"
      )
    end

    it "creates the new path" do
      expect { execute }.to change { File.exist?(Pathname(root).join("README.md")) }
        .from(false)
        .to(true)
    end

    it "deletes the old path" do
      expect { execute }.to change { File.exist?(Pathname(root).join("README.txt")) }
        .from(true)
        .to(false)
    end
  end
end
