# frozen_string_literal: true

RSpec.describe OmniAI::Tools::Disk::FileReplaceTool do
  subject(:tool) { described_class.new(root:) }

  let(:root) do
    dir = Dir.mktmpdir
    File.write(File.join(dir, "README.md"), "Hello George!")
    dir
  end

  around do |example|
    example.run
  ensure
    FileUtils.remove_entry(root)
  end

  describe "#execute" do
    subject(:execute) { tool.execute(old_text: "George", new_text: "Ringo", path: "./README.md") }

    it "replaces the text 'George' with the text 'Ringo" do
      expect { execute }.to change { File.read(File.join(root, "README.md")) }
        .from("Hello George!")
        .to("Hello Ringo!")
    end
  end
end
