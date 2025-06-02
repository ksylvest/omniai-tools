# frozen_string_literal: true

RSpec.describe OmniAI::Tools::Disk::DirectoryMoveTool do
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
    subject(:execute) { tool.execute(old_path: "./source", new_path: "./destination") }

    let(:source_path) { Pathname(root).join("source") }
    let(:destination_path) { Pathname(root).join("destination") }

    before do
      FileUtils.mkdir_p(source_path)
    end

    it "moves the directory from old_path to new_path" do
      expect { execute }.to change { Dir.exist?(source_path) }
        .from(true)
        .to(false)
        .and change { Dir.exist?(destination_path) }
        .from(false)
        .to(true)
    end

    context "when source directory doesn't exist" do
      before do
        FileUtils.remove_entry(source_path)
      end

      it "raises an error" do
        expect { execute }.to raise_error(Errno::ENOENT)
      end
    end

    context "when destination already exists" do
      before do
        FileUtils.mkdir_p(destination_path)
      end

      it "moves source into destination as a subdirectory" do
        execute
        expect(Dir.exist?(destination_path.join("source"))).to be true
        expect(Dir.exist?(source_path)).to be false
      end
    end

    context "with nested directories" do
      subject(:execute) { tool.execute(old_path: "./deep/source", new_path: "./deep/destination") }

      let(:source_path) { Pathname(root).join("deep/source") }
      let(:destination_path) { Pathname(root).join("deep/destination") }

      before do
        FileUtils.mkdir_p(source_path)
      end

      it "moves nested directories" do
        expect { execute }.to change { Dir.exist?(source_path) }
          .from(true)
          .to(false)
          .and change { Dir.exist?(destination_path) }
          .from(false)
          .to(true)
      end
    end
  end
end
