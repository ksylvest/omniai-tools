# frozen_string_literal: true

RSpec.describe OmniAI::Tools::DiskTool do
  subject(:tool) { described_class.new(driver:, logger:) }

  let(:root) { ROOT.join("spec", "fixtures", "project") }
  let(:driver) { OmniAI::Tools::Disk::BaseDriver.new(root:) }
  let(:logger) { Logger.new(IO::NULL) }

  describe "#execute" do
    context "when the action is 'directory_create'" do
      subject(:execute) { tool.execute(action: described_class::Action::DIRECTORY_CREATE, path:) }

      let(:path) { "./demo" }

      it "uses the driver" do
        allow(driver).to receive(:directory_create)
        execute
        expect(driver).to have_received(:directory_create).with(path:)
      end
    end

    context "when the action is 'directory_delete'" do
      subject(:execute) { tool.execute(action: described_class::Action::DIRECTORY_DELETE, path:) }

      let(:path) { "./demo" }

      it "uses the driver" do
        allow(driver).to receive(:directory_delete)
        execute
        expect(driver).to have_received(:directory_delete).with(path:)
      end
    end

    context "when the action is 'directory_move'" do
      subject(:execute) { tool.execute(action: described_class::Action::DIRECTORY_MOVE, path:, destination:) }

      let(:path) { "./demo" }
      let(:destination) { "./example" }

      it "uses the driver" do
        allow(driver).to receive(:directory_move)
        execute
        expect(driver).to have_received(:directory_move).with(path:, destination:)
      end
    end

    context "when the action is 'directory_list'" do
      subject(:execute) { tool.execute(action: described_class::Action::DIRECTORY_LIST, path:) }

      let(:path) { "/demo.txt" }

      it "uses the driver" do
        allow(driver).to receive(:directory_list)
        execute
        expect(driver).to have_received(:directory_list).with(path:)
      end
    end

    context "when the action is 'file_create'" do
      subject(:execute) { tool.execute(action: described_class::Action::FILE_CREATE, path:) }

      let(:path) { "/demo.txt" }

      it "uses the driver" do
        allow(driver).to receive(:file_create)
        execute
        expect(driver).to have_received(:file_create).with(path:)
      end
    end

    context "when the action is 'file_delete'" do
      subject(:execute) { tool.execute(action: described_class::Action::FILE_DELETE, path:) }

      let(:path) { "/demo.txt" }

      it "uses the driver" do
        allow(driver).to receive(:file_delete)
        execute
        expect(driver).to have_received(:file_delete).with(path:)
      end
    end

    context "when the action is 'file_move'" do
      subject(:execute) { tool.execute(action: described_class::Action::FILE_MOVE, path:, destination:) }

      let(:path) { "/demo.txt" }
      let(:destination) { "/example.txt" }

      it "uses the driver" do
        allow(driver).to receive(:file_move)
        execute
        expect(driver).to have_received(:file_move).with(path:, destination:)
      end
    end

    context "when the action is 'file_read'" do
      subject(:execute) { tool.execute(action: described_class::Action::FILE_READ, path:) }

      let(:path) { "/demo.txt" }

      it "uses the driver" do
        allow(driver).to receive(:file_read)
        execute
        expect(driver).to have_received(:file_read).with(path:)
      end
    end

    context "when the action is 'file_write'" do
      subject(:execute) { tool.execute(action: described_class::Action::FILE_WRITE, path:, text:) }

      let(:path) { "./demo.txt" }
      let(:text) { "hello" }

      it "uses the driver" do
        allow(driver).to receive(:file_write)
        execute
        expect(driver).to have_received(:file_write).with(path:, text:)
      end
    end

    context "when the action is 'file_replace'" do
      subject(:execute) { tool.execute(action: described_class::Action::FILE_REPLACE, path:, old_text:, new_text:) }

      let(:path) { "./demo.txt" }
      let(:old_text) { "foo" }
      let(:new_text) { "bar" }

      it "uses the driver" do
        allow(driver).to receive(:file_replace)
        execute
        expect(driver).to have_received(:file_replace).with(path:, old_text:, new_text:)
      end
    end
  end
end
