# frozen_string_literal: true

RSpec.describe OmniAI::Tools::Disk::DirectoryDeleteTool do
  subject(:tool) { described_class.new(root:) }

  let(:root) do
    dir = Dir.mktmpdir
    FileUtils.mkdir(File.join(dir, "example"))
    dir
  end

  around do |example|
    example.run
  ensure
    FileUtils.remove_entry(root)
  end

  describe "#execute" do
    subject(:execute) { tool.execute(path: "example") }

    it "creates a directory" do
      expect { execute }
        .to(change { File.exist?(File.join(root, "example")) })
    end
  end
end
