# frozen_string_literal: true

RSpec.describe OmniAI::Tools::Disk::DirectoryCreateTool do
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
    subject(:execute) { tool.execute(path: "./example") }

    it "creates a directory" do
      expect { execute }.to change { File.exist?(Pathname(root).join("example")) }
        .from(false)
        .to(true)
    end
  end
end
