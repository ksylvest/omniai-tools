# frozen_string_literal: true

RSpec.describe OmniAI::Tools::Disk::FileReadTool do
  subject(:tool) { described_class.new(root:) }

  let(:root) do
    dir = Dir.mktmpdir
    File.write(File.join(dir, "README.md"), "Hello World")
    dir
  end

  around do |example|
    example.run
  ensure
    FileUtils.remove_entry(root)
  end

  describe "#execute" do
    subject(:execute) { tool.execute(path: "./README.md") }

    it "reads the file" do
      expect(execute).to eql("Hello World")
    end
  end
end
